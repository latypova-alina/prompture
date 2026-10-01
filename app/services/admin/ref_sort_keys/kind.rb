module Admin
  module RefSortKeys
    class Kind < Base
      def value(_plucked, _created_at)
        Admin::CommandRequestsQuery::TYPES.include?(klass) ? "Command" : "Button"
      end
    end
  end
end
