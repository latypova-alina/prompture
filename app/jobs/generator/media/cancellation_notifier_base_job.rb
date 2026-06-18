module Generator
  module Media
    class CancellationNotifierBaseJob < ApplicationJob
      include Memery

      def perform(button_request_id)
        @button_request_id = button_request_id

        with_locale(locale) do
          Telegram.bot.send_message(**message_data)
        end

        request.update!(status: "CANCELLED")
      end

      private

      attr_reader :button_request_id

      delegate :chat_id, :locale, :humanized_process_name, to: :request

      def message_text
        raise NotImplementedError
      end

      def request_class
        raise NotImplementedError
      end

      def message_data
        {
          chat_id:,
          text: message_text,
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
