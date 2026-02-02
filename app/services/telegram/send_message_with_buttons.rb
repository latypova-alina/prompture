module Telegram
  class SendMessageWithButtons
    def self.call(chat_id:, reply_data:, request:)
      response = ::Telegram.bot.send_message(chat_id:, **reply_data)

      TelegramMessage.create!(
        tg_message_id: response.dig("result", "message_id"),
        request:,
        chat_id:
      )
    end
  end
end
