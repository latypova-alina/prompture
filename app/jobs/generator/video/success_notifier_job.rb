module Generator
  module Video
    class SuccessNotifierJob < BaseNotifierJob
      include Memery

      def perform(video_url, button_request_id)
        @video_url = video_url
        @button_request_id = button_request_id

        with_locale(locale) do
          ::Telegram.bot.send_message(chat_id:, **reply_data)

          request.update!(status: "COMPLETED", video_url:)
        end
      end

      private

      delegate :reply_data, to: :presenter
      delegate :chat_id, to: :request

      attr_reader :video_url, :button_request_id

      memoize def presenter
        MediaGenerator::ButtonRequestPresenters::VideoProcessedMessagePresenter.new(message: video_url)
      end
    end
  end
end
