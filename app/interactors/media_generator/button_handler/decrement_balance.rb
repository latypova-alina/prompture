module MediaGenerator
  module ButtonHandler
    class DecrementBalance
      include Interactor
      include Memery

      delegate :chat_id, :button_request_record, to: :context
      delegate :cost, to: :button_request_record
      delegate :user, to: :command_request

      def call
        return if cost.zero?

        Billing::Charger.call(user:, amount: cost, source: button_request_record)
      rescue InsufficientCreditsError => e
        context.fail!(error: e.class)
      end
    end
  end
end
