module Generator
  module Prompt
    class ErrorNotifierJob
      def perform(chat_id)
        Telegram.bot.send_message(
          chat_id: chat_id,
          text: I18n.t("errors.extend_prompt_error")
        )
      end
    end
  end
end
