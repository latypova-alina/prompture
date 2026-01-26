module Telegram
  class SendMessageWithButtons
    def self.call(chat_id:, presenter:, request:)
      response = ::Telegram.bot.send_message(chat_id:, **presenter.reply_data)

      ButtonParentMessage.create!(
        tg_message_id: response.dig("result", "message_id"),
        request:
      )
    end
  end
end
