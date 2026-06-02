module ScriptGenerator
  module JobErrorHandler
    EXPLICIT_MESSAGE_ALLOWED_ERRORS = [ScriptGeneratorRequestError].freeze

    private

    def notify_script_generator_error(chat_id:, error: nil)
      TelegramIntegration::DeleteAdminProcessingMessage.call(chat_id:)
      Telegram.bot.send_message(chat_id:, text: error_message(error))
    end

    def error_message(error)
      return error.message if explicit_message_allowed?(error) && error.message.present?

      I18n.t("errors.script_generator_request_failed")
    end

    def explicit_message_allowed?(error)
      EXPLICIT_MESSAGE_ALLOWED_ERRORS.any? { |error_class| error.is_a?(error_class) }
    end
  end
end
