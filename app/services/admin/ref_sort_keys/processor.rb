module Admin
  module RefSortKeys
    class Processor < Base
      include Memery

      def expression
        :processor if column?("processor")
      end

      def value(plucked, _created_at)
        plucked || fixed_processor
      end

      private

      # ButtonExtendPromptRequest has no processor column, just a fixed #processor.
      memoize def fixed_processor
        klass.new.try(:processor)
      end
    end
  end
end
