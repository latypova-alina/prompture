module Generator
  module Media
    class ErrorNotifierBaseJob < ApplicationJob
      include Memery

      def perform(button_request_id, error_reason = nil)
        @button_request_id = button_request_id
        @error_reason = error_reason

        with_locale(locale) do
          Telegram.bot.send_message(**message_data)
        end

        request.update!(status: "FAILED")
      end

      private

      attr_reader :button_request_id, :error_reason

      delegate :chat_id, :locale, :parent_request, to: :request
      delegate :bot_telegram_message, to: :parent_request, prefix: true, allow_nil: true
      delegate :tg_message_id, to: :parent_request_bot_telegram_message, prefix: true, allow_nil: true

      def custom_error_text
        return if error_reason.blank?

        I18n.t("errors.#{error_reason}")
      end

      def error_text
        raise NotImplementedError
      end

      def request_class
        raise NotImplementedError
      end

      def message_data
        {
          chat_id:,
          text: custom_error_text || error_text,
          reply_to_message_id: original_prompt_message_id
        }.compact
      end

      def original_prompt_message_id
        parent_request_bot_telegram_message_tg_message_id
      end

      memoize def request
        request_class.includes(:parent_request, command_request: :user).find(button_request_id)
      end
    end
  end
end
