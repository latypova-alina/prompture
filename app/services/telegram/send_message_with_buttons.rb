module Telegram
  class SendMessageWithButtons
    def self.call(chat_id:, reply_data:, request:)
      response = ::Telegram.bot.send_message(chat_id:, **reply_data)

      ButtonParentMessage.create!(
        tg_message_id: response.dig("result", "message_id"),
        request:
      )
    end
  end
end
