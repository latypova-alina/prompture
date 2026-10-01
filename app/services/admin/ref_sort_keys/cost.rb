module Admin
  module RefSortKeys
    # Cost isn't a column - it's computed from the processor, once per distinct processor.
    class Cost < Base
      include Memery

      def expression
        :processor if column?("processor")
      end

      def value(plucked, _created_at)
        cost_for(plucked)
      end

      private

      memoize def cost_for(processor)
        Admin::ButtonRequestCost.call(klass, processor)
      end
    end
  end
end
