module Generator
  module Media
    class TaskRetrieverBaseJob < ApplicationJob
      include Memery

      def perform(task_id, button_request_id, processor)
        @task_id = task_id
        @processor = processor

        success_notifier_job_class.perform_async(media_url, button_request_id)
      rescue Freepik::ResponseError
        error_notifier_job_class.perform_async(button_request_id)
      end

      private

      attr_reader :task_id, :processor

      delegate :media_url, to: :task_retriever

      memoize def task_retriever
        task_retriever_class.new(task_id, processor)
      end

      def task_retriever_class
        raise NotImplementedError
      end

      def success_notifier_job_class
        raise NotImplementedError
      end

      def error_notifier_job_class
        raise NotImplementedError
      end
    end
  end
end
