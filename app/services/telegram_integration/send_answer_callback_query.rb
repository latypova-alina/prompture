module TelegramIntegration
  class SendAnswerCallbackQuery
    def self.call(...)
      new(...).call
    end

    def initialize(callback_query_id:, button_request: nil, process_name: nil)
      @callback_query_id = callback_query_id
      @button_request = button_request
      @explicit_process_name = process_name
    end

    def call
      Telegram.bot.answer_callback_query(
        callback_query_id:,
        text: I18n.t("telegram.generation.processing", process_name: humanized_process_name),
        show_alert: false
      )
    rescue Telegram::Bot::Error
      nil
    end

    private

    attr_reader :callback_query_id, :button_request, :explicit_process_name

    def humanized_process_name
      explicit_process_name || button_request.humanized_process_name
    end
  end
end
