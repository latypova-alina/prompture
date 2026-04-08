module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      class NotifyUser
        include Interactor

        delegate :image_record, to: :context

        def call
          TelegramIntegration::SendMessageWithButtons.call(
            reply_data:,
            request: image_record
          )
        end

        private

        delegate :reply_data, to: :presenter

        def presenter
          MediaGenerator::UserMessage::ImageMessage::PresenterSelector.new(request: image_record).presenter
        end
      end
    end
  end
end
