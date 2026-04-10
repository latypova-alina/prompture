module TelegramIntegration
  class CallbackQueryDispatcher
    include Memery

    SET_LOCALE_COMMAND = "set_locale".freeze

    def self.call(...)
      new(...).call
    end

    def initialize(button_request:, chat_id:, tg_message_id:, callback_query_id:)
      @button_request = button_request
      @chat_id = chat_id
      @tg_message_id = tg_message_id
      @callback_query_id = callback_query_id
    end

    def call
      raise handled_button.error if handled_button.failure?
    end

    private

    attr_reader :button_request, :chat_id, :tg_message_id, :callback_query_id

    def handled_button
      case splitted_button_request.first
      when SET_LOCALE_COMMAND
        SetLocale::ButtonHandler::HandleButton.call(selected_locale: splitted_button_request.last, chat_id:)
      else
        MediaGenerator::ButtonHandler::HandleButton.call(
          button_request:,
          chat_id:,
          tg_message_id:,
          callback_query_id:
        )
      end
    end

    memoize def splitted_button_request
      button_request.split(":")
    end
  end
end
