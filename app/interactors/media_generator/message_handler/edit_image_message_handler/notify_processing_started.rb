module MediaGenerator
  module MessageHandler
    module EditImageMessageHandler
      class NotifyProcessingStarted
        include Interactor

        delegate :button_request_record, :command_request, to: :context

        def call
          TelegramIntegration::RecordBotTelegramMessage.call(
            response: send_processing_message,
            request: button_request_record
          )
        end

        private

        def send_processing_message
          Telegram.bot.send_message(
            chat_id: command_request.chat_id,
            text: I18n.t(
              "telegram.generation.processing",
              process_name: button_request_record.humanized_process_name
            )
          )
        end
      end
    end
  end
end
