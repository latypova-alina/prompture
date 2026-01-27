module Generator
  module Video
    class SuccessNotifierJob
      include Sidekiq::Job
      include Memery

      def perform(video_url, chat_id, button_request_id)
        @video_url = video_url
        @button_request_id = button_request_id

        ::Telegram.bot.send_message(chat_id:, **reply_data)

        request.update!(status: "COMPLETED", video_url:)
      end

      private

      delegate :reply_data, to: :presenter
      attr_reader :video_url, :button_request_id

      memoize def presenter
        ::ButtonRequestPresenters::VideoProcessedMessagePresenter.new(video_url)
      end

      memoize def request
        ButtonVideoProcessingRequest.find(button_request_id)
      end
    end
  end
end
