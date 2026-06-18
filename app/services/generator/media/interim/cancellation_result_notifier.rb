module Generator
  module Media
    module Interim
      class CancellationResultNotifier
        def self.call(generation_request:, callback_query_id:, success:)
          new(generation_request:, callback_query_id:, success:).call
        end

        def initialize(generation_request:, callback_query_id:, success:)
          @generation_request = generation_request
          @callback_query_id = callback_query_id
          @success = success
        end

        def call
          return answer_callback_query_with_alert(I18n.t("errors.generation_cancel_requested")) if success?

          notify_user(I18n.t("errors.generation_cancel_failed"))

          answer_callback_query
        end

        private

        attr_reader :generation_request, :callback_query_id, :success

        alias success? success

        delegate :chat_id, to: :generation_request

        def answer_callback_query_with_alert(text)
          TelegramIntegration::SendAlertCallbackQuery.call(
            callback_query_id:,
            text:
          )
        end

        def notify_user(text)
          Telegram.bot.send_message(chat_id:, text:)
        end

        def answer_callback_query
          Telegram.bot.answer_callback_query(callback_query_id:)
        end
      end
    end
  end
end
