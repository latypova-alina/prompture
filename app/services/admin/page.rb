module Admin
  class Page
    PER_PAGE = 20

    Result = Struct.new(:records, :current_page, :total_pages, :total_count, keyword_init: true)

    def self.call(...)
      new(...).call
    end

    def initialize(collection, page: 1)
      @collection = collection
      @page = [page.to_i, 1].max
    end

    def call
      Result.new(
        records: collection.slice(offset, PER_PAGE) || [],
        current_page: page,
        total_pages: total_pages,
        total_count: collection.size
      )
    end

    private

    attr_reader :collection, :page

    def offset
      (page - 1) * PER_PAGE
    end

    def total_pages
      [(collection.size / PER_PAGE.to_f).ceil, 1].max
    end
  end
end
