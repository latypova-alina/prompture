module Admin
  module RefSortKeys
    class Category < Base
      def expression
        :category if column?("category")
      end
    end
  end
end
