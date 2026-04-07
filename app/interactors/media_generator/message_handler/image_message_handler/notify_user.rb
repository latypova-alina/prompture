module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      class NotifyUser
        include Interactor

        delegate :image_url_message, :picture_message, to: :context

        def call
          TelegramIntegration::SendMessageWithButtons.call(
            reply_data:,
            request:
          )
        end

        private

        delegate :reply_data, to: :presenter

        def request
          image_url_message || picture_message
        end

        def presenter
          MediaGenerator::UserMessage::ImageMessage::PresenterSelector.new(request:).presenter
        end
      end
    end
  end
end
