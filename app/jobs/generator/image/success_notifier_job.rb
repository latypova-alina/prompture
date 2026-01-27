module Generator
  module Image
    class SuccessNotifierJob
      include Sidekiq::Job

      def perform(image_url, chat_id, button_request_id)
        @image_url = image_url
        @button_request_id = button_request_id

        ::Telegram.bot.send_message(chat_id:, **reply_data)

        request.update!(status: "COMPLETED", image_url:)
      end

      private

      delegate :reply_data, to: :presenter
      attr_reader :image_url, :button_request_id

      def presenter
        ButtonRequestPresenters::ImageProcessedMessagePresenter.new(image_url)
      end

      def request
        ButtonImageProcessingRequest.find(button_request_id)
      end
    end
  end
end
