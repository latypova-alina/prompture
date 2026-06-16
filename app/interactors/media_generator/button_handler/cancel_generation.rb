module MediaGenerator
  module ButtonHandler
    class CancelGeneration
      include Interactor
      include Memery
      include LocaleSupport

      delegate :button_request, :callback_query_id, to: :context

      def call
        with_locale(locale) do
          canceller.call
          handle_canceller_result
          answer_callback_query
        end
      rescue StandardError
        notify_user(I18n.t("errors.generation_cancel_failed"))
      end

      private

      delegate :locale, to: :generation_request
      delegate :chat_id, to: :generation_request

      memoize def canceller
        Generator::Media::CancelFalRequest.new(generation_request)
      end

      def handle_canceller_result
        return notify_user(I18n.t("errors.generation_cancelled")) if canceller.success?

        notify_user(I18n.t("errors.generation_cancel_failed"))
      end

      def answer_callback_query
        Telegram.bot.answer_callback_query(callback_query_id:)
      end

      def notify_user(text)
        Telegram.bot.send_message(chat_id:, text:)
      end

      memoize def generation_request
        request_id, request_type = button_request.split(":").last(2)

        request_type.constantize.find(request_id)
      end
    end
  end
end
