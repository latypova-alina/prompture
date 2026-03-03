module Generator
  module Media
    module Image
      class SuccessNotifierJob < BaseNotifierJob
        include Memery

        def perform(image_url, button_request_id)
          @image_url = image_url
          @button_request_id = button_request_id

          with_locale(locale) do
            TelegramIntegration::SendMessageWithButtons.call(
              reply_data:,
              request:
            )
          end

          request.update!(status: "COMPLETED", image_url:)
        end

        private

        delegate :reply_data, to: :presenter
        delegate :presenter, to: :presenter_selector

        attr_reader :image_url, :button_request_id

        memoize def presenter_selector
          MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::PresenterSelector.new(
            image_url, command_request_classname, locale
          )
        end

        memoize def command_request_classname
          request.command_request.class.name
        end
      end
    end
  end
end
