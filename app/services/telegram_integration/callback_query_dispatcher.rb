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
      return unless handled_button.failure?

      return notify_image_not_ready if image_not_ready_error?

      raise handled_button.error
    end

    private

    attr_reader :button_request, :chat_id, :tg_message_id, :callback_query_id

    def image_not_ready_error?
      handled_button.error == ImageNotReadyError
    end

    def notify_image_not_ready
      SendAlertCallbackQuery.call(
        callback_query_id:,
        text: I18n.t("errors.image_not_ready")
      )
    end

    def handled_button
      case splitted_button_request.first
      when SET_LOCALE_COMMAND
        handle_set_locale
      else
        handle_media_button
      end
    end

    memoize def splitted_button_request
      button_request.split(":")
    end

    def handle_set_locale
      SetLocale::ButtonHandler::HandleButton.call(selected_locale: splitted_button_request.last, chat_id:)
    end

    def handle_media_button
      MediaGenerator::ButtonHandler::HandleButton.call(**media_button_handler_params)
    end

    def media_button_handler_params
      {
        button_request:,
        chat_id:,
        tg_message_id:,
        callback_query_id:
      }
    end
  end
end
