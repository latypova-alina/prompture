module Admin
  class UsersQuery
    SORT_KEYS = %w[id name locale balance admin].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(sort: Admin::SortParams::DEFAULT)
      @sort = sort
    end

    def call
      relation = User.includes(:balance).left_joins(:balance)
      relation = relation.order(Arel.sql(order_sql)) if order_sql
      relation.order(created_at: :desc, id: :desc)
    end

    private

    attr_reader :sort

    delegate :sql_direction, to: :sort

    # Only whitelisted keys and ASC/DESC from Admin::Sort ever reach the SQL.
    def order_sql
      case sort.key
      when "id" then "users.id #{sql_direction}"
      when "name" then "LOWER(users.name) #{sql_direction}"
      when "locale" then "users.locale #{sql_direction}"
      when "balance" then "COALESCE(balances.credits, 0) #{sql_direction}"
      when "admin" then "users.admin #{sql_direction}"
      end
    end
  end
end
