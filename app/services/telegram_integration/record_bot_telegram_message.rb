module TelegramIntegration
  class RecordBotTelegramMessage
    def self.call(response:, request:)
      BotTelegramMessage.create!(
        tg_message_id: response.dig("result", "message_id"),
        request:,
        chat_id: request.chat_id
      )
    end
  end
end
