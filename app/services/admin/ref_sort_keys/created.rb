module Admin
  module RefSortKeys
    class Created < Base
      def value(_plucked, created_at)
        created_at
      end
    end
  end
end
