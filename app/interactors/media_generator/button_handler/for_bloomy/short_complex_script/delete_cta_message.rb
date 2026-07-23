module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module ShortComplexScript
        class DeleteCtaMessage
          include Interactor

          delegate :chat_id, :tg_message_id, to: :context

          def call
            TelegramIntegration::DeleteMessage.call(chat_id:, message_id: tg_message_id)
          end
        end
      end
    end
  end
end
