module Generator
  module Prompt
    class ErrorNotifierJob < BaseNotifierJob
      def perform(chat_id, button_request_id)
        @button_request_id = button_request_id

        with_locale(locale) do
          Telegram.bot.send_message(
            chat_id:,
            text: I18n.t("errors.extend_prompt_error")
          )
        end
      end

      private

      attr_reader :button_request_id
    end
  end
end
