module Admin
  class HasButtonRequestsFilter
    def initialize(value)
      @value = value
    end

    def apply(relation, klass)
      case value
      when "with"
        relation.merge(matching(klass))
      when "without"
        relation.where.not(id: matching(klass).select(:id))
      else
        relation
      end
    end

    private

    attr_reader :value

    def matching(klass)
      Admin::ButtonRequestTypes::ALL.reduce(klass.none) do |rel, button_klass|
        rel.or(klass.where(id: button_klass.where(command_request_type: klass.name).select(:command_request_id)))
      end
    end
  end
end
