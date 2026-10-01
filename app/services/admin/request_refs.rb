module Admin
  class RequestRefs
    def self.call(...)
      new(...).call
    end

    def initialize(filters:)
      @filters = filters
      @date_range = Admin::DateRangeFilter.new(date_from: filters.date_from, date_to: filters.date_to)
    end

    def call
      (command_refs + button_refs).sort_by(&:created_at).reverse
    end

    private

    attr_reader :filters, :date_range

    delegate :user_search, to: :filters

    def command_refs
      Admin::CommandRequestsQuery::TYPES.flat_map { |klass| refs_for(klass, scoped_command(klass)) }
    end

    def button_refs
      Admin::ButtonRequestTypes::ALL.flat_map { |klass| refs_for(klass, scoped_button(klass)) }
    end

    def refs_for(klass, relation)
      date_range.apply(relation).pluck(:id, :created_at).map do |id, created_at|
        Admin::RequestRef.new(klass, id, created_at)
      end
    end

    def scoped_command(klass)
      return klass.all unless user_search.present?

      klass.where(user: Admin::UserSearch.call(user_search))
    end

    def scoped_button(klass)
      Admin::ButtonRequestScope.call(klass:, filters: Admin::ButtonRequestsQuery::Filters.new(user_search:))
    end
  end
end
