module ScriptProcessor
  class CreateBotTelegramMessage
    include Interactor

    delegate :prompt_message, :chat_id, to: :context

    def call
      context.bot_message = BotTelegramMessage.create!(
        request: prompt_message,
        chat_id:,
        tg_message_id: next_tg_message_id
      )
    end

    private

    def next_tg_message_id
      BotTelegramMessage.where(chat_id:).maximum(:tg_message_id).to_i + 1
    end
  end
end
