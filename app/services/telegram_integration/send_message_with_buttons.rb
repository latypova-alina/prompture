module TelegramIntegration
  class SendMessageWithButtons
    def self.call(reply_data:, request:)
      response = ::Telegram.bot.send_message(chat_id: request.chat_id, **reply_data)

      RecordBotTelegramMessage.call(response:, request:)
    end
  end
end
