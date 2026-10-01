module Admin
  class RequestRefs
    def self.call(...)
      new(...).call
    end

    def initialize(filters:, sort:)
      @filters = filters
      @sort = sort
      @date_range = Admin::DateRangeFilter.new(date_from:, date_to:)
    end

    def call
      Admin::RefsFromRelations.call(command_relations.merge(button_relations), sort:)
    end

    private

    attr_reader :filters, :sort, :date_range

    delegate :user_search, :date_from, :date_to, to: :filters

    def command_relations
      Admin::CommandRequestsQuery::TYPES.index_with { |klass| date_range.apply(scoped_command(klass)) }
    end

    def button_relations
      Admin::ButtonRequestTypes::ALL.index_with { |klass| date_range.apply(scoped_button(klass)) }
    end

    def scoped_command(klass)
      return klass.all if user_search.blank?

      klass.where(user: Admin::UserSearch.call(user_search))
    end

    def scoped_button(klass)
      Admin::ButtonRequestScope.call(klass:, filters: Admin::ButtonRequestsQuery::Filters.new(user_search:))
    end
  end
end
