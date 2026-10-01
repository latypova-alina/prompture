module Admin
  class RequestsQuery
    Filters = Struct.new(:user_search, :date_from, :date_to, keyword_init: true)
    SORT_KEYS = %w[kind type user status created].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(filters: Filters.new, sort: Admin::SortParams::DEFAULT, page: 1)
      @filters = filters
      @sort = sort
      @page = page
    end

    def call
      page_result = Admin::Page.call(refs, page:)
      page_result.records = Admin::RequestHydration.call(page_result.records)
      page_result
    end

    private

    attr_reader :filters, :sort, :page

    def refs
      Admin::RequestRefs.call(filters:, sort:)
    end
  end
end
