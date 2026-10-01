module Admin
  class ButtonRequestsQuery
    Filters = Struct.new(:type, :status, :processor, :command_type, :user_search, :date_from, :date_to,
                         keyword_init: true)
    SORT_KEYS = %w[user type processor status cost command created].freeze

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
      @page = page
    end

    def call
      page_result = Admin::Page.call(Admin::RefsFromRelations.call(relations, sort:), page:)
      page_result.records = Admin::RequestHydration.call(page_result.records)
      page_result
    end

    def count
      relations.values.sum(&:count)
    end

    private

    attr_reader :user, :filters, :sort, :page

    def relations
      Admin::ButtonRequestRelations.call(user:, filters:)
    end
  end
end
