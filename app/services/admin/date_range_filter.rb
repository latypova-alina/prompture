module Admin
  class DateRangeFilter
    def initialize(date_from: nil, date_to: nil)
      @date_from = parse(date_from)
      @date_to = parse(date_to)
    end

    def apply(relation)
      relation = relation.where(created_at: date_from.beginning_of_day..) if date_from
      relation = relation.where(created_at: ..date_to.end_of_day) if date_to
      relation
    end

    private

    attr_reader :date_from, :date_to

    def parse(value)
      return nil if value.blank?

      Date.parse(value)
    rescue ArgumentError, TypeError
      nil
    end
  end
end
