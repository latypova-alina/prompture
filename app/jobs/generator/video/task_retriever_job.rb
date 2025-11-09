module Generator
  module Video
    class TaskRetrieverJob < ::Clients::Generator::BaseApiRequest
      include Sidekiq::Job
      include Memery

      def perform(task_id, chat_id)
        @task_id = task_id

        raise ::Freepik::ResponseError unless response.success?

        ::Generator::Video::SuccessNotifierJob.perform_async(video_url, chat_id)
      rescue ::Freepik::ResponseError
        ::Generator::Video::ErrorNotifierJob.perform_async(chat_id)
      end

      def video_url
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
