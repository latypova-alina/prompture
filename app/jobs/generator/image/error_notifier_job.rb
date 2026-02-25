module Generator
  module Image
    class ErrorNotifierJob < ApplicationJob
      def perform(chat_id, locale)
        with_locale(locale) do
          Telegram.bot.send_message(
            chat_id: chat_id,
            text: I18n.t("errors.image_generating_error")
          )
        end
      end
    end
  end
end
