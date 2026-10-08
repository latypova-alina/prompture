module MediaGenerator
  module ButtonHandler
    class DecrementBalance
      include Interactor
      include Memery

      delegate :chat_id, :button_request_record, :command_request, to: :context
      delegate :cost, to: :button_request_record
      delegate :user, to: :command_request

      def call
        return if cost.zero?

        Billing::Charger.call(user:, amount: cost, source: button_request_record)
      rescue InsufficientCreditsError => e
        record_failure
        context.fail!(error: e.class)
      end

      private

      # The request was already created, so finalize it instead of leaving it PENDING forever.
      def record_failure
        ButtonRequests::FailureRecorder.call(
          button_request: button_request_record,
          reason: ButtonRequests::FailureRecorder::INSUFFICIENT_CREDITS
        )
      end
    end
  end
end
