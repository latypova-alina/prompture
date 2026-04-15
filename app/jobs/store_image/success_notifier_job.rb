module StoreImage
  class SuccessNotifierJob < BaseNotifierJob
    private

    delegate :reply_data, to: :presenter
    delegate :tg_message_id, to: :image_record

    memoize def presenter
      MediaGenerator::UserMessage::ImageMessage::PresenterSelector.new(request: image_record).presenter
    end

    def notify
      TelegramIntegration::SendMessageWithButtons.call(
        reply_data: reply_data_with_reply_reference,
        request: image_record
      )
    end

    def reply_data_with_reply_reference
      reply_data.merge(reply_to_message_id: tg_message_id).compact
    end
  end
end
