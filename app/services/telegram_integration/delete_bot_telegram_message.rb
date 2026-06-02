module TelegramIntegration
  class DeleteBotTelegramMessage
    def self.call(request:)
      new(request:).call
    end

    def initialize(request:)
      @request = request
    end

    def call
      return if request.blank? || bot_telegram_message.blank?

      delete_telegram_message
      bot_telegram_message.destroy!
    rescue StandardError
      bot_telegram_message.destroy! if bot_telegram_message.persisted?
    end

    private

    attr_reader :request

    delegate :bot_telegram_message, to: :request
    delegate :chat_id, :tg_message_id, to: :bot_telegram_message

    def delete_telegram_message
      Telegram.bot.delete_message(chat_id:, message_id: tg_message_id)
    end
  end
end
