module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      class NotifyUser
        include Interactor

        delegate :image_record, to: :context

        def call
          TelegramIntegration::SendMessageWithButtons.call(
            reply_data: reply_data_with_reply_reference,
            request: image_record
          )
        end

        private

        delegate :reply_data, to: :presenter
        delegate :tg_message_id, to: :image_record

        def reply_data_with_reply_reference
          reply_data.merge(reply_to_message_id: tg_message_id).compact
        end

        def presenter
          MediaGenerator::UserMessage::ImageMessage::PresenterSelector.new(request: image_record).presenter
        end
      end
    end
  end
end
