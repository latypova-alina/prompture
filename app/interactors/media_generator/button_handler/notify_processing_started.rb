module MediaGenerator
  module ButtonHandler
    class NotifyProcessingStarted
      include Interactor
      include Memery

      delegate :callback_query_id, :button_request_record, to: :context

      def call
        TelegramIntegration::SendAnswerCallbackQuery.call(
          callback_query_id:,
          button_request: button_request_record
        )
      end
    end
  end
end
