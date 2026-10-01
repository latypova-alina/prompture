module Admin
  module RefSortKeys
    class Type < Base
      def value(_plucked, _created_at)
        klass.name
      end
    end
  end
end
