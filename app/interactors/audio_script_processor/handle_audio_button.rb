module AudioScriptProcessor
  class HandleAudioButton
    include Interactor
    include Memery

    AUDIO_BUTTON = "elevenlabs_turbo_v2_5_audio".freeze

    delegate :chat_id, :prompt_message, to: :context

    def call
      context.fail!(error: ParentNotFoundError) if bot_message.blank?

      context.fail!(error: handled_button.error) if handled_button.failure?
    end

    private

    memoize def handled_button
      MediaGenerator::ButtonHandler::HandleButton.call(
        button_request: AUDIO_BUTTON,
        chat_id:,
        tg_message_id: bot_message.tg_message_id,
        callback_query_id: nil
      )
    end

    def bot_message
      prompt_message.reload.bot_telegram_message
    end
  end
end
