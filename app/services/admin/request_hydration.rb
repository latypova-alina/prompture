module Admin
  # Loads the real records for a page of refs, keeping the refs' (already sorted) order.
  module RequestHydration
    def self.call(refs)
      records = refs.group_by(&:klass).flat_map { |klass, klass_refs| hydrate_klass(klass, klass_refs) }
      by_ref = records.index_by { |record| [record.class, record.id] }
      refs.filter_map { |ref| by_ref[[ref.klass, ref.id]] }
    end

    def self.hydrate_klass(klass, klass_refs)
      ids = klass_refs.map(&:id)

      if Admin::CommandRequestsQuery::TYPES.include?(klass)
        klass.includes(:user).where(id: ids)
      else
        Admin::ButtonRequestEagerLoad.call(klass).where(id: ids)
      end
    end

    private_class_method :hydrate_klass
  end
end
