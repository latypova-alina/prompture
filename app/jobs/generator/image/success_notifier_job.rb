module Generator
  module Image
    class SuccessNotifierJob < ApplicationJob
      include Memery

      def perform(image_url, chat_id, button_request_id, locale)
        @image_url = image_url
        @button_request_id = button_request_id

        with_locale(locale) do
          TelegramIntegration::SendMessageWithButtons.call(
            chat_id:,
            reply_data:,
            request:
          )
        end

        request.update!(status: "COMPLETED", image_url:)
      end

      memoize def locale
        request.user.locale.to_s
      end

      private

      delegate :reply_data, to: :presenter
      delegate :presenter, to: :presenter_selector

      attr_reader :image_url, :button_request_id

      memoize def presenter_selector
        ButtonRequestPresenters::ImageProcessedMessage::PresenterSelector.new(image_url, command_request_classname,
                                                                              locale)
      end

      memoize def command_request_classname
        request.command_request.class.name
      end

      memoize def request
        ButtonImageProcessingRequest
          .includes(command_request: :user)
          .find(button_request_id)
      end
    end
  end
end
