module Generator
  module Media
    module Interim
      class CancellationHandler
        include Memery

        def self.call(generation_request:, callback_query_id:)
          new(generation_request:, callback_query_id:).call
        end

        def initialize(generation_request:, callback_query_id:)
          @generation_request = generation_request
          @callback_query_id = callback_query_id
        end

        def call
          canceller.call
          notify_user(result_message)
          answer_callback_query
        end

        private

        attr_reader :generation_request, :callback_query_id

        delegate :chat_id, to: :generation_request

        memoize def canceller
          Generator::Media::CancelFalRequest.new(generation_request)
        end

        def result_message
          return I18n.t("errors.generation_cancelled") if canceller.success?

          I18n.t("errors.generation_cancel_failed")
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
