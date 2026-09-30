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

    Filters = Struct.new(:type, :user_search, :has_button_requests, :date_from, :date_to, keyword_init: true)
    Ref = Struct.new(:klass, :id, :created_at)

    def self.call(...)
      new(...).call
    end

    def self.count(...)
      new(...).count
    end

    def initialize(user: nil, filters: Filters.new, page: 1)
      @user = user
      @filters = filters
      @date_range = Admin::DateRangeFilter.new(date_from: filters.date_from, date_to: filters.date_to)
      @has_button_requests_filter = Admin::HasButtonRequestsFilter.new(filters.has_button_requests)
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

    attr_reader :user, :filters, :date_range, :has_button_requests_filter, :page

    delegate :type, :user_search, to: :filters

    # Only id/created_at are pulled here so pagination/sorting across the (potentially
    # hundreds of) matching rows per type doesn't instantiate full records for rows that
    # get discarded once sliced to a page.
    def refs
      classes.flat_map do |klass|
        scoped(klass).pluck(:id, :created_at).map { |id, created_at| Ref.new(klass, id, created_at) }
      end.sort_by(&:created_at).reverse
    end

    def hydrate(refs)
      records = refs.group_by(&:klass).flat_map do |klass, klass_refs|
        klass.includes(:user).where(id: klass_refs.map(&:id))
      end
      records.sort_by(&:created_at).reverse
    end

    def scoped(klass)
      relation = date_range.apply(apply_user_scope(klass.all))
      has_button_requests_filter.apply(relation, klass)
    end

    def apply_user_scope(relation)
      return relation.where(user:) if user.present?
      return relation.where(user: Admin::UserSearch.call(user_search)) if user_search.present?

      relation
    end

    def classes
      matched = TYPES.select { |klass| klass.name == type }
      matched.presence || TYPES
    end
  end
end
