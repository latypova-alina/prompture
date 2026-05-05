module ScriptProcessor
  class HandleFluxButton
    include Interactor

    FLUX_BUTTON = "flux_image".freeze

    delegate :chat_id, :prompt_message, to: :context

    def call
      context.fail!(error: ParentNotFoundError) if bot_message.blank?

      handled_button = MediaGenerator::ButtonHandler::HandleButton.call(
        button_request: FLUX_BUTTON,
        chat_id:,
        tg_message_id: bot_message.tg_message_id,
        callback_query_id: nil
      )

      context.fail!(error: handled_button.error) if handled_button.failure?
    end

    private

    def bot_message
      prompt_message.reload.bot_telegram_message
    end
  end
end
