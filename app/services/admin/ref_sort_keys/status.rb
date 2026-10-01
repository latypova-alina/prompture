module Admin
  module RefSortKeys
    # Case-insensitive: DB-default rows are lowercase "pending". Command requests have no status.
    class Status < Base
      def expression
        Arel.sql("UPPER(#{klass.quoted_table_name}.status)") if column?("status")
      end
    end
  end
end
