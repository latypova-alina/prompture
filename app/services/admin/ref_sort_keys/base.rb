module Admin
  module RefSortKeys
    class Base
      def initialize(klass)
        @klass = klass
      end

      # Extra SQL expression to pluck, or nil when the value is derived in Ruby.
      def expression; end

      def value(plucked, _created_at)
        plucked
      end

      private

      attr_reader :klass

      def column?(name)
        klass.column_names.include?(name)
      end
    end
  end
end
