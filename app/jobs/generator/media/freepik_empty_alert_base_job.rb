module Generator
  module Media
    class FreepikEmptyAlertBaseJob < ApplicationJob
      include Memery

      def perform(button_request_id)
        @button_request_id = button_request_id

        with_locale(locale) do
          Telegram.bot.send_message(
            chat_id:,
            text: error_text
          )
        end

        Billing::Refunder.call(user:, amount: cost, source: request)
        request.update!(status: "FAILED")
      end

      private

      attr_reader :button_request_id

      delegate :chat_id, :locale, :user, :cost, to: :request

      def error_text
        raise NotImplementedError
      end

      def request_class
        raise NotImplementedError
      end

      memoize def request
        request_class.includes(:parent_request, command_request: :user).find(button_request_id)
      end
    end
  end
end
