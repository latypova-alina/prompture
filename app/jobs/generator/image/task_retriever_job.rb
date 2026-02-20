module Generator
  module Image
    class TaskRetrieverJob < ApplicationJob
      include ::Clients::Generator::BaseApiRequest
      include Memery
      include WithLocaleInterface

      def perform(task_id, chat_id, button_request_id)
        @task_id = task_id
        @button_request_id = button_request_id

        raise ::Freepik::ResponseError unless response.success?

        ::Generator::Image::SuccessNotifierJob.perform_async(image_url, chat_id, button_request_id, locale)
      rescue ::Freepik::ResponseError
        ::Generator::Image::ErrorNotifierJob.perform_async(chat_id, locale)
      end

      def image_url
        response_body.dig("data", "generated")[0]
      end

      private

      attr_reader :task_id, :button_request_id

      memoize def response
        connection.get(task_id)
      end

      memoize def response_body
        JSON.parse(response.body)
      end

      def request_class
        ButtonImageProcessingRequest
      end
    end
  end
end
