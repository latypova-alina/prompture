module Generator
  module Media
    class TaskRetrieverDispatcher
      TASK_RETRIEVER_JOBS_BY_PROCESSOR = {}.freeze

      def self.call(...)
        new(...).call
      end

      def initialize(task_id:, button_request_id:, processor:)
        @task_id = task_id
        @button_request_id = button_request_id
        @processor = processor
      end

      def call
        task_retriever_job&.perform_async(task_id, button_request_id, processor)
      end

      private

      attr_reader :task_id, :button_request_id, :processor

      def task_retriever_job
        TASK_RETRIEVER_JOBS_BY_PROCESSOR[processor]
      end
    end
  end
end
