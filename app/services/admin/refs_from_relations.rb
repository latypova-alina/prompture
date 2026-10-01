module Admin
  # Builds sorted refs from a { klass => relation } hash. Only id/created_at (plus the sort value)
  # are plucked, so pagination/sorting across the (potentially hundreds of) matching rows doesn't
  # instantiate full records - or eager-load their associations - for rows that get discarded once
  # sliced to a page.
  class RefsFromRelations
    def self.call(...)
      new(...).call
    end

    def initialize(relations, sort:)
      @relations = relations
      @sort = sort
    end

    def call
      Admin::RefSorter.call(refs, sort:)
    end

    private

    attr_reader :relations, :sort

    def refs
      relations.flat_map { |klass, relation| refs_for(klass, relation) }
    end

    def refs_for(klass, relation)
      sort_values = Admin::RefSortValues.new(klass:, key: sort.key)
      columns = [:id, :created_at, sort_values.expression].compact

      relation.pluck(*columns).map do |id, created_at, plucked|
        Admin::RequestRef.new(klass, id, created_at, sort_values.value(plucked, created_at))
      end
    end
  end
end
