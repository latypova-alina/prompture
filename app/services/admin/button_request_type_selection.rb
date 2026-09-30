module Admin
  class ButtonRequestTypeSelection
    def self.call(...)
      new(...).call
    end

    def initialize(filters:)
      @filters = filters
    end

    # ButtonExtendPromptRequest has no processor column, so a processor filter excludes
    # it entirely rather than falling back to "all types" the way an unmatched type does.
    def call
      return matching_types unless filters.processor.present?

      matching_types.select { |klass| klass.column_names.include?("processor") }
    end

    private

    attr_reader :filters

    def matching_types
      matched = Admin::ButtonRequestTypes::ALL.select { |klass| klass.name == filters.type }
      matched.presence || Admin::ButtonRequestTypes::ALL
    end
  end
end
