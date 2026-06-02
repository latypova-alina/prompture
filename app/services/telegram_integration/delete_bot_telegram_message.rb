module TelegramIntegration
  class DeleteBotTelegramMessage
    def self.call(request:)
      message = request.bot_telegram_message
      return if message.blank?

      new(message).call
    end

    def initialize(message)
      @message = message
    end

    def call
      Telegram.bot.delete_message(chat_id: message.chat_id, message_id: message.tg_message_id)
      message.destroy!
    rescue StandardError
      message.destroy! if message.persisted?
    end

    private

    attr_reader :message
  end
end
