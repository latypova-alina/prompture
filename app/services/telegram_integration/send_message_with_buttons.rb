module TelegramIntegration
  class SendMessageWithButtons
    def self.call(reply_data:, request:)
      response = ::Telegram.bot.send_message(chat_id: request.chat_id, **reply_data)

      BotTelegramMessage.create!(
        tg_message_id: response.dig("result", "message_id"),
        request:,
        chat_id: request.chat_id
      )
    end
  end
end
