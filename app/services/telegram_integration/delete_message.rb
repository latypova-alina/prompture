module TelegramIntegration
  class DeleteMessage
    def self.call(chat_id:, message_id:)
      return unless message_id

      Telegram.bot.delete_message(chat_id:, message_id:)
    rescue Telegram::Bot::Error
      nil
    end
  end
end
