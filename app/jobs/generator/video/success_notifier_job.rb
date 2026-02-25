module Generator
  module Video
    class SuccessNotifierJob < ApplicationJob
      include Memery

      def perform(video_url, chat_id, button_request_id, locale)
        with_locale(locale) do
          @video_url = video_url
          @button_request_id = button_request_id

          ::Telegram.bot.send_message(chat_id:, **reply_data)

          request.update!(status: "COMPLETED", video_url:)
        end
      end

      private

      delegate :reply_data, to: :presenter
      attr_reader :video_url, :button_request_id

      memoize def presenter
        MediaGenerator::ButtonRequestPresenters::VideoProcessedMessagePresenter.new(message: video_url)
      end

      memoize def request
        ButtonVideoProcessingRequest
          .includes(command_request: :user)
          .find(button_request_id)
      end
    end
  end
end
