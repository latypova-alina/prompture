module TelegramIntegration
  class SendAlertCallbackQuery
    def self.call(...)
      new(...).call
    end

    def initialize(callback_query_id:, text:)
      @callback_query_id = callback_query_id
      @text = text
    end

    def call
      Telegram.bot.answer_callback_query(
        callback_query_id:,
        text:,
        show_alert: true
      )
    end

    private

    attr_reader :callback_query_id, :text
  end
end
