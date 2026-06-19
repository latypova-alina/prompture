module Generator
  module Media
    module Interim
      module Notifier
        class Base
          def self.call(...)
            new(...).call
          end

          def initialize(generation_request:, callback_query_id:)
            @generation_request = generation_request
            @callback_query_id = callback_query_id
          end

          def call
            raise NotImplementedError
          end

          private

          attr_reader :generation_request, :callback_query_id

          delegate :chat_id, :humanized_process_name, to: :generation_request

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
end
