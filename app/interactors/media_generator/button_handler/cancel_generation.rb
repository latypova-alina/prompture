module MediaGenerator
  module ButtonHandler
    class CancelGeneration
      include Interactor
      include Memery
      include LocaleSupport

      delegate :button_request, :callback_query_id, to: :context

      def call
        with_locale(locale) do
          Generator::Media::Interim::CancellationHandler.call(
            generation_request:,
            callback_query_id:
          )
        end
      rescue StandardError
        notify_user(I18n.t("errors.generation_cancel_failed"))
      end

      private

      delegate :locale, :chat_id, to: :generation_request

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
