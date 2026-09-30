module Admin
  class ButtonRequestsQuery
    Filters = Struct.new(:type, :status, :processor, :command_type, :date_from, :date_to, keyword_init: true)
    Ref = Struct.new(:klass, :id, :created_at)

    def self.call(...)
      new(...).call
    end

    def self.count(...)
      new(...).count
    end

    def initialize(user:, filters: Filters.new, page: 1)
      @user = user
      @filters = filters
      @date_range = Admin::DateRangeFilter.new(date_from: filters.date_from, date_to: filters.date_to)
      @page = page
    end

    def call
      page_result = Admin::Page.call(refs, page:)
      page_result.records = hydrate(page_result.records)
      page_result
    end

    def count
      classes.sum { |klass| date_range.apply(scope_for(klass)).count }
    end

    private

    attr_reader :user, :filters, :date_range, :page

    # Only id/created_at are pulled here so pagination/sorting across the (potentially
    # hundreds of) matching rows per type doesn't instantiate full records - or, worse,
    # eager-load their associations - for rows that get discarded once sliced to a page.
    def refs
      classes.flat_map do |klass|
        date_range.apply(scope_for(klass)).pluck(:id, :created_at).map do |id, created_at|
          Ref.new(klass, id, created_at)
        end
      end.sort_by(&:created_at).reverse
    end

    def hydrate(refs)
      records = refs.group_by(&:klass).flat_map do |klass, klass_refs|
        Admin::ButtonRequestEagerLoad.call(klass).where(id: klass_refs.map(&:id))
      end
      records.sort_by(&:created_at).reverse
    end

    def classes
      Admin::ButtonRequestTypeSelection.call(filters:)
    end

    def scope_for(klass)
      Admin::ButtonRequestScope.call(klass:, user:, filters:)
    end
  end
end
