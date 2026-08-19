module Generator
  module Media
    class ErrorNotifierBaseJob < ApplicationJob
      include Memery

      def perform(button_request_id, error_reason = nil, flagged_message = nil)
        @button_request_id = button_request_id
        @error_reason = error_reason
        @flagged_message = flagged_message

        with_locale(locale) do
          Telegram.bot.send_message(**message_data)
        end

        request.update!(status: "FAILED")
      end

      private

      attr_reader :button_request_id, :error_reason, :flagged_message

      delegate :chat_id, :locale, to: :request

      def custom_error_text
        return if error_reason.blank?

        I18n.t("errors.#{error_reason}", **i18n_interpolations)
      end

      def i18n_interpolations
        return {} if flagged_message.blank?

        { message: flagged_message }
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
        request.origin_telegram_message_id
      end

      memoize def request
        request_class.includes(:parent_request, command_request: :user).find(button_request_id)
      end
    end
  end
end
