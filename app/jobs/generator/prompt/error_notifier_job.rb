module Generator
  module Prompt
    class ErrorNotifierJob < ApplicationJob
      def perform(chat_id, locale)
        with_locale(locale) do
          Telegram.bot.send_message(
            chat_id: chat_id,
            text: I18n.t("errors.extend_prompt_error")
          )
        end
      end
    end
  end
end
