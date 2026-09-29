module Admin
  class CommandRequestsQuery
    TYPES = [
      CommandPromptToImageRequest,
      CommandPromptToVideoRequest,
      CommandImageToVideoRequest,
      CommandTwoFrameToVideoRequest,
      CommandEditImageRequest,
      CommandPromptToAudioRequest
    ].freeze

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
      classes.sum { |klass| scoped(klass).count }
    end

    private

    attr_reader :user, :type, :date_range, :page

    # Only id/created_at are pulled here so pagination/sorting across the (potentially
    # hundreds of) matching rows per type doesn't instantiate full records for rows that
    # get discarded once sliced to a page.
    def refs
      classes.flat_map do |klass|
        scoped(klass).pluck(:id, :created_at).map { |id, created_at| Ref.new(klass, id, created_at) }
      end.sort_by(&:created_at).reverse
    end

    def hydrate(refs)
      records = refs.group_by(&:klass).flat_map { |klass, klass_refs| klass.where(id: klass_refs.map(&:id)) }
      records.sort_by(&:created_at).reverse
    end

    def scoped(klass)
      date_range.apply(klass.where(user:))
    end

    def classes
      matched = TYPES.select { |klass| klass.name == type }
      matched.presence || TYPES
    end
  end
end
