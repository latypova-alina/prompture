module Admin
  class RequestsQuery
    Filters = Struct.new(:user_search, :date_from, :date_to, keyword_init: true)

    def self.call(...)
      new(...).call
    end

    def initialize(filters: Filters.new, page: 1)
      @filters = filters
      @page = page
    end

    def call
      page_result = Admin::Page.call(refs, page:)
      page_result.records = Admin::RequestHydration.call(page_result.records)
      page_result
    end

    private

    attr_reader :filters, :page

    def refs
      Admin::RequestRefs.call(filters:)
    end
  end
end
