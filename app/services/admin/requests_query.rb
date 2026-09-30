module Admin
  class RequestsQuery
    Filters = Struct.new(:user_search, :date_from, :date_to, keyword_init: true)
    Ref = Struct.new(:klass, :id, :created_at)

    def self.call(...)
      new(...).call
    end

    def initialize(filters: Filters.new, page: 1)
      @filters = filters
      @date_range = Admin::DateRangeFilter.new(date_from: filters.date_from, date_to: filters.date_to)
      @page = page
    end

    def call
      page_result = Admin::Page.call(refs, page:)
      page_result.records = hydrate(page_result.records)
      page_result
    end

    private

    attr_reader :filters, :date_range, :page

    delegate :user_search, to: :filters

    # Only id/created_at are pulled here so pagination/sorting across the (potentially
    # large) combined set of command + button requests doesn't instantiate full records -
    # or eager-load their associations - for rows that get discarded once sliced to a page.
    def refs
      (command_refs + button_refs).sort_by(&:created_at).reverse
    end

    def command_refs
      Admin::CommandRequestsQuery::TYPES.flat_map do |klass|
        date_range.apply(scoped_command(klass)).pluck(:id, :created_at).map do |id, created_at|
          Ref.new(klass, id, created_at)
        end
      end
    end

    def button_refs
      Admin::ButtonRequestTypes::ALL.flat_map do |klass|
        date_range.apply(scoped_button(klass)).pluck(:id, :created_at).map do |id, created_at|
          Ref.new(klass, id, created_at)
        end
      end
    end

    def scoped_command(klass)
      return klass.all unless user_search.present?

      klass.where(user: Admin::UserSearch.call(user_search))
    end

    def scoped_button(klass)
      Admin::ButtonRequestScope.call(klass:, filters: button_filters)
    end

    def button_filters
      Admin::ButtonRequestsQuery::Filters.new(user_search:)
    end

    def hydrate(refs)
      records = refs.group_by(&:klass).flat_map { |klass, klass_refs| hydrate_klass(klass, klass_refs) }
      records.sort_by(&:created_at).reverse
    end

    def hydrate_klass(klass, klass_refs)
      ids = klass_refs.map(&:id)

      if Admin::CommandRequestsQuery::TYPES.include?(klass)
        klass.includes(:user).where(id: ids)
      else
        Admin::ButtonRequestEagerLoad.call(klass).where(id: ids)
      end
    end
  end
end
