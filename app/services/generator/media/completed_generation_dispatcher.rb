module Generator
  module Media
    class CompletedGenerationDispatcher
      WEBHOOK_RETRIEVER_JOBS_BY_PROCESSOR = [
        *Generator::Processors::ALL_IMAGE.product([Image::TaskRetrieverJob]),
        *Generator::Processors::VIDEO.product([Video::FalTaskRetrieverJob]),
        *Generator::Processors::AUDIO.product([Audio::FalTaskRetrieverJob])
      ].to_h.freeze

      def self.call(...)
        new(...).call
      end

      def initialize(processor:, button_request_id:, generated:, task_id:)
        @processor = processor
        @button_request_id = button_request_id
        @generated = generated
        @task_id = task_id
      end

      def call
        return empty_generation_alert if generated.empty?

        dispatch_retrieval
      end

      private

      attr_reader :processor, :button_request_id, :generated, :task_id

      def empty_generation_alert
        EmptyGenerationAlert.call(processor:, button_request_id:)
      end

      def dispatch_retrieval
        return enqueue_webhook_retriever if webhook_retriever_job

        TaskRetrieverDispatcher.call(task_id:, button_request_id:, processor:)
      end

      def enqueue_webhook_retriever
        webhook_retriever_job.perform_async(generated.first, button_request_id, processor)
      end

      def webhook_retriever_job
        WEBHOOK_RETRIEVER_JOBS_BY_PROCESSOR[processor]
      end
    end
  end
end
