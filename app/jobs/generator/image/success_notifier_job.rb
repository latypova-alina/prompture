module Generator
  module Image
    class SuccessNotifierJob
      include Sidekiq::Job
      include Memery

      def perform(image_url, chat_id, button_request_id)
        @image_url = image_url
        @button_request_id = button_request_id

        Telegram::SendMessageWithButtons.call(
          chat_id:,
          reply_data:,
          request:
        )

        request.update!(status: "COMPLETED", image_url:)
      end

      private

      delegate :reply_data, to: :presenter
      delegate :presenter, to: :presenter_selector

      attr_reader :image_url, :button_request_id

      memoize def presenter_selector
        ButtonRequestPresenters::ImageProcessedMessage::PresenterSelector.new(image_url, command_request_classname)
      end

      memoize def command_request_classname
        request.command_request.class.name
      end

      memoize def request
        ButtonImageProcessingRequest.find(button_request_id)
      end
    end
  end
end
