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

    Ref = Struct.new(:klass, :id, :created_at)

    def self.call(...)
      new(...).call
    end

    def self.count(...)
      new(...).count
    end

    def initialize(user:, type: nil, date_from: nil, date_to: nil, page: 1)
      @user = user
      @type = type
      @date_range = Admin::DateRangeFilter.new(date_from:, date_to:)
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

    attr_reader :user, :type, :date_range, :page

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

    def classes
      matched = TYPES.select { |klass| klass.name == type }
      matched.presence || TYPES
    end

    def filtered(klass)
      Admin::CommandRequestsQuery::TYPES.reduce(klass.none) do |rel, command_klass|
        rel.or(
          klass.where(command_request_type: command_klass.name,
                      command_request_id: command_klass.where(user:).select(:id))
        )
      end
    end

    def eager(klass)
      relation = klass.includes(command_request: :user)
      relation = relation.includes(MEDIA_ASSOCIATIONS[klass]) if MEDIA_ASSOCIATIONS[klass]
      relation
    end
  end
end
