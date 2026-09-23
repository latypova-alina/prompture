module TelegramIntegration
  class SendMessageWithButtons
    def self.call(reply_data:, request:)
      response = ::Telegram.bot.send_message(chat_id: request.chat_id, **reply_data)

      bot_telegram_message = BotTelegramMessage.find_or_initialize_by(
        chat_id: request.chat_id,
        tg_message_id: response.dig("result", "message_id")
      )
      bot_telegram_message.request = request
      bot_telegram_message.save!
    end
  end
end
