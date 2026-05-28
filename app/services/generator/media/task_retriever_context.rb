module Generator
  module Media
    module TaskRetrieverContext
      FAL_RETRIEVER_CONTEXT = FluxTaskRetrieverContext

      PROCESSOR_RETRIEVER_CONTEXTS =
        Generator::Processors::FAL_IMAGE.index_with { FAL_RETRIEVER_CONTEXT }.freeze

      def self.for(params:)
        PROCESSOR_RETRIEVER_CONTEXTS
          .fetch(params[:processor], FreepikTaskRetrieverContext)
          .new(params:)
      end
    end
  end
end
