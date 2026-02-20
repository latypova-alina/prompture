module Generator
  module Video
    class ErrorNotifierJob < ApplicationJob
      include Memery

      def perform(chat_id, locale)
        with_locale(locale) do
          Telegram.bot.send_message(
            chat_id: chat_id,
            text:
         I18n.t("errors.video_generating_error")
          )
        end
      end
    end
  end
end
