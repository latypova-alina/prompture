module StoreImage
  class SuccessNotifierJob < BaseNotifierJob
    private

    delegate :presenter, to: :presenter_selector
    delegate :reply_data, to: :presenter
    delegate :tg_message_id, :user, to: :image_record

    memoize def presenter_selector
      MediaGenerator::UserMessage::ImageMessage::PresenterSelector.new(request: image_record)
    end

    def notify
      return send_terms_gate unless policy_accepted?

      TelegramIntegration::SendMessageWithButtons.call(
        reply_data: reply_data_with_reply_reference,
        request: image_record
      )
    end

    def policy_accepted?
      MiniApp::CurrentPolicyAcceptance.new(user:).present?
    end

    def send_terms_gate
      TelegramIntegration::SendMessageWithButtons.call(
        reply_data: terms_gate_reply_data,
        request: image_record
      )
    end

    def terms_gate_reply_data
      terms_gate_presenter.reply_data.merge(reply_to_message_id: tg_message_id).compact
    end

    def terms_gate_presenter
      StoreImage::TermsGatePresenter.new(record_type:, record_id:, locale:)
    end

    def reply_data_with_reply_reference
      reply_data.merge(reply_to_message_id: tg_message_id).compact
    end
  end
end
