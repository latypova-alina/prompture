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
    SORT_KEYS = %w[user type category created].freeze

    def self.call(...)
      new(...).call
    end

    def self.count(...)
      new(...).count
    end

    def initialize(user: nil, filters: Filters.new, sort: Admin::SortParams::DEFAULT, page: 1)
      @user = user
      @filters = filters
      @sort = sort
      @date_range = Admin::DateRangeFilter.new(date_from: filters.date_from, date_to: filters.date_to)
      @has_button_requests_filter = Admin::HasButtonRequestsFilter.new(filters.has_button_requests)
      @page = page
    end

    def call
      page_result = Admin::Page.call(refs, page:)
      page_result.records = Admin::RequestHydration.call(page_result.records)
      page_result
    end

    def count
      classes.sum { |klass| scoped(klass).count }
    end

    private

    attr_reader :user, :filters, :sort, :date_range, :has_button_requests_filter, :page

    delegate :type, :user_search, to: :filters

    def refs
      Admin::RefsFromRelations.call(classes.index_with { |klass| scoped(klass) }, sort:)
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
