module Generator
  module Media
    module TaskRetrieverContext
      PROCESSOR_RETRIEVER_CONTEXTS = {
        "flux_image" => FluxTaskRetrieverContext
      }.freeze

      def self.for(params:)
        PROCESSOR_RETRIEVER_CONTEXTS
          .fetch(params[:processor], FreepikTaskRetrieverContext)
          .new(params:)
      end
    end
  end
end
