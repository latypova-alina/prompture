module Admin
  class ButtonRequestsQuery
    TYPES = [
      ButtonImageProcessingRequest,
      ButtonVideoProcessingRequest,
      ButtonAudioProcessingRequest,
      ButtonMergeAudioVideoProcessingRequest,
      ButtonExtendPromptRequest
    ].freeze

    MEDIA_ASSOCIATIONS = {
      ButtonImageProcessingRequest => :stored_image,
      ButtonVideoProcessingRequest => :stored_video,
      ButtonMergeAudioVideoProcessingRequest => :stored_video
    }.freeze

    # The DB default is lowercase "pending", but application code (success/failure
    # notifiers) writes these uppercase values - #apply_status matches case-insensitively
    # so rows still on the DB default aren't silently excluded.
    STATUSES = %w[PENDING COMPLETED FAILED CANCELLED].freeze

    Filters = Struct.new(:type, :status, :processor, :command_type, :date_from, :date_to, keyword_init: true)
    Ref = Struct.new(:klass, :id, :created_at)

    def self.call(...)
      new(...).call
    end

    def self.count(...)
      new(...).count
    end

    def self.processor_options
      TYPES.select { |klass| klass.column_names.include?("processor") }
           .flat_map { |klass| klass::PROCESSOR_TYPES }
           .uniq
    end

    def initialize(user:, filters: Filters.new, page: 1)
      @user = user
      @filters = filters
      @date_range = Admin::DateRangeFilter.new(date_from: filters.date_from, date_to: filters.date_to)
      @page = page
    end

    def call
      page_result = Admin::Page.call(refs, page:)
      page_result.records = hydrate(page_result.records)
      page_result
    end

    def count
      classes.sum { |klass| date_range.apply(filtered(klass)).count }
    end

    private

    attr_reader :user, :filters, :date_range, :page

    delegate :type, :status, :processor, :command_type, to: :filters

    # Only id/created_at are pulled here so pagination/sorting across the (potentially
    # hundreds of) matching rows per type doesn't instantiate full records - or, worse,
    # eager-load their associations - for rows that get discarded once sliced to a page.
    def refs
      classes.flat_map do |klass|
        date_range.apply(filtered(klass)).pluck(:id, :created_at).map do |id, created_at|
          Ref.new(klass, id, created_at)
        end
      end.sort_by(&:created_at).reverse
    end

    def hydrate(refs)
      records = refs.group_by(&:klass).flat_map do |klass, klass_refs|
        eager(klass).where(id: klass_refs.map(&:id))
      end
      records.sort_by(&:created_at).reverse
    end

    # ButtonExtendPromptRequest has no processor column, so a processor filter excludes
    # it entirely rather than falling back to "all types" the way an unmatched type does.
    def classes
      return matching_types unless processor.present?

      matching_types.select { |klass| klass.column_names.include?("processor") }
    end

    def matching_types
      matched = TYPES.select { |klass| klass.name == type }
      matched.presence || TYPES
    end

    def command_types
      matched = Admin::CommandRequestsQuery::TYPES.select { |klass| klass.name == command_type }
      matched.presence || Admin::CommandRequestsQuery::TYPES
    end

    def filtered(klass)
      relation = scoped_by_command_type(klass)
      relation = apply_status(relation)
      apply_processor(relation)
    end

    def scoped_by_command_type(klass)
      command_types.reduce(klass.none) do |rel, command_klass|
        rel.or(
          klass.where(command_request_type: command_klass.name,
                      command_request_id: command_klass.where(user:).select(:id))
        )
      end
    end

    def apply_status(relation)
      return relation unless status.present?

      relation.where("upper(status) = ?", status.upcase)
    end

    def apply_processor(relation)
      return relation unless processor.present?

      relation.where(processor:)
    end

    def eager(klass)
      relation = klass.includes(command_request: :user)
      relation = relation.includes(MEDIA_ASSOCIATIONS[klass]) if MEDIA_ASSOCIATIONS[klass]
      relation
    end
  end
end
