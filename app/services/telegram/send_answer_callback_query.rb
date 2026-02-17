module Telegram
  class SendAnswerCallbackQuery
    def self.call(...)
      new(...).call
    end

    def initialize(callback_query_id:, button_request:)
      @callback_query_id = callback_query_id
      @button_request = button_request
    end

    def call
      Telegram.bot.answer_callback_query(
        callback_query_id:,
        text: I18n.t("telegram.generation.processing", process_name: humanized_process_name),
        show_alert: false
      )
    end

    private

    attr_reader :callback_query_id, :button_request

    delegate :humanized_process_name, to: :button_request
  end
end
