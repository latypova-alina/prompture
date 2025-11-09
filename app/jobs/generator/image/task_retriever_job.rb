module Generator
  module Image
    class TaskRetrieverJob < ::Clients::Generator::BaseApiRequest
      include Sidekiq::Job
      include Memery

      def perform(task_id, chat_id)
        @task_id = task_id

        raise ::Freepik::ResponseError unless response.success?

        ::Generator::Image::SuccessNotifierJob.perform_async(image_url, chat_id)
      rescue ::Freepik::ResponseError
        ::Generator::Image::ErrorNotifierJob.perform_async(chat_id)
      end

      def image_url
        response_body.dig("data", "generated")[0]
      end

      private

      attr_reader :task_id

      memoize def response
        connection.get(task_id)
      end

      memoize def response_body
        JSON.parse(response.body)
      end
    end
  end
end
