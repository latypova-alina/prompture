module Generator
  module Media
    module TaskRetrieverContext
      def self.for(params:)
        context_class(params[:processor]).new(params:)
      end

      def self.context_class(processor)
        return ImageTaskRetrieverContext if Generator::Processors::IMAGE.include?(processor)

        FreepikTaskRetrieverContext
      end
    end
  end
end
