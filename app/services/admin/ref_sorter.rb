module Admin
  # Orders request refs by their sort value in the given direction, always putting nil values last,
  # and breaking ties by created_at desc then id desc so pages stay stable.
  class RefSorter
    def self.call(...)
      new(...).call
    end

    def initialize(refs, sort:)
      @refs = refs
      @sort = sort
    end

    def call
      with_value, without_value = refs.partition { |ref| !ref.sort_value.nil? }
      with_value.sort { |left, right| compare(left, right) } +
        without_value.sort { |left, right| tie_break(left, right) }
    end

    private

    attr_reader :refs, :sort

    def compare(left, right)
      result = left.sort_value <=> right.sort_value
      result = -result if sort.desc?
      result.zero? ? tie_break(left, right) : result
    end

    def tie_break(left, right)
      [right.created_at, right.id] <=> [left.created_at, left.id]
    end
  end
end
