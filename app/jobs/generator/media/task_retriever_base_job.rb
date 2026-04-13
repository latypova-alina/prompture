module Generator
  module Media
    class TaskRetrieverBaseJob < ApplicationJob
      include Memery

      def perform(task_id, button_request_id, processor)
        @task_id = task_id
        @button_request_id = button_request_id
        @processor = processor

        success_notifier_job_class.perform_async(media_url, button_request_id)
      rescue Freepik::ResponseError
        error_notifier_job_class.perform_async(button_request_id)
      end

      private

      attr_reader :task_id, :button_request_id, :processor

      delegate :media_url, to: :task_retriever, prefix: :generated
      delegate :internal_media_url, to: :stored_media

      memoize def task_retriever
        task_retriever_class.new(task_id, processor)
      end

      memoize def stored_media
        Generator::Media::StoredMedia::Retriever.new(media_url: generated_media_url, button_request_id:, processor:)
      end

      def media_url
        internal_media_url || generated_media_url
      rescue StandardError
        generated_media_url
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
