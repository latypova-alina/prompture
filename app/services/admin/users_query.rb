module Admin
  class UsersQuery
    SORT_KEYS = %w[id name locale balance admin].freeze
    BLOCKED_FILTERS = %w[blocked not_blocked].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(sort: Admin::SortParams::DEFAULT, blocked: nil)
      @sort = sort
      @blocked = blocked
    end

    def call
      relation = filtered(User.includes(:balance).left_joins(:balance))
      relation = relation.order(Arel.sql(order_sql)) if order_sql
      relation.order(created_at: :desc, id: :desc)
    end

    private

    attr_reader :sort, :blocked

    delegate :sql_direction, to: :sort

    def filtered(relation)
      case blocked
      when "blocked" then relation.where.not(blocked_at: nil)
      when "not_blocked" then relation.where(blocked_at: nil)
      else relation
      end
    end

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
