module Admin
  module RequestHydration
    def self.call(refs)
      records = refs.group_by(&:klass).flat_map { |klass, klass_refs| hydrate_klass(klass, klass_refs) }
      records.sort_by(&:created_at).reverse
    end

    def self.hydrate_klass(klass, klass_refs)
      ids = klass_refs.map(&:id)

      if Admin::CommandRequestsQuery::TYPES.include?(klass)
        klass.includes(:user).where(id: ids)
      else
        Admin::ButtonRequestEagerLoad.call(klass).where(id: ids)
      end
    end
  end
end
