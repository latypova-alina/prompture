module ScriptProcessor
  class HandleFluxButton
    include Interactor

    FLUX_BUTTON = "flux_image".freeze

    delegate :chat_id, :bot_message, to: :context

    def call
      handled_button = MediaGenerator::ButtonHandler::HandleButton.call(
        button_request: FLUX_BUTTON,
        chat_id:,
        tg_message_id: bot_message.tg_message_id,
        callback_query_id: nil
      )

      context.fail!(error: handled_button.error) if handled_button.failure?
    end
  end
end
