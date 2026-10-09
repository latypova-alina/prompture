module ButtonRequests
  # Finalizes a button request that will never be processed: FAILED plus why. A nil reason or
  # message keeps what was recorded earlier instead of erasing it.
  class FailureRecorder
    STATUS = "FAILED".freeze

    INSUFFICIENT_CREDITS = "insufficient_credits".freeze
    ABANDONED_BEFORE_CHARGE = "abandoned_before_charge".freeze

    def self.call(...)
      new(...).call
    end

    def initialize(button_request:, reason:, message: nil)
      @button_request = button_request
      @reason = reason
      @message = message
    end

    def call
      button_request.update!(
        status: STATUS,
        failure_reason: reason || failure_reason,
        failure_message: message || failure_message
      )
    end

    private

    attr_reader :button_request, :reason, :message

    delegate :failure_reason, :failure_message, to: :button_request
  end
end
