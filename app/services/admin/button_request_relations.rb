module Admin
  class ButtonRequestRelations
    def self.call(...)
      new(...).call
    end

    def initialize(filters:, user: nil)
      @user = user
      @filters = filters
      @date_range = Admin::DateRangeFilter.new(date_from: filters.date_from, date_to: filters.date_to)
    end

    def call
      classes.index_with { |klass| date_range.apply(scope_for(klass)) }
    end

    private

    attr_reader :user, :filters, :date_range

    def classes
      Admin::ButtonRequestTypeSelection.call(filters:)
    end

    def scope_for(klass)
      Admin::ButtonRequestScope.call(klass:, user:, filters:)
    end
  end
end
