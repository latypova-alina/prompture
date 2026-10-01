module Admin
  module RefSortKeys
    class User < Base
      def expression
        Arel.sql(Admin::UserNameSql.call(klass))
      end
    end
  end
end
