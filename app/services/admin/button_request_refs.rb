module Admin
  module ButtonRequestRefs
    # Only id/created_at are pulled here so pagination/sorting across the (potentially
    # hundreds of) matching rows per type doesn't instantiate full records - or, worse,
    # eager-load their associations - for rows that get discarded once sliced to a page.
    def self.call(relations)
      refs = relations.flat_map do |klass, relation|
        relation.pluck(:id, :created_at).map { |id, created_at| Admin::RequestRef.new(klass, id, created_at) }
      end
      refs.sort_by(&:created_at).reverse
    end
  end
end
