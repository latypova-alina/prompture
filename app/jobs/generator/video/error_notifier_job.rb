module Generator
  module Video
    class ErrorNotifierJob
      def perform(chat_id)
        Telegram.bot.send_message(
          chat_id: chat_id,
          text: I18n.t("errors.video_generating_error")
        )
      end
    end
  end
end
