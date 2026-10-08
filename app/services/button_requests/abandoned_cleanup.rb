module ButtonRequests
  # One-off: marks abandoned PENDING button requests (see AbandonedSelection) as FAILED with
  # "abandoned_before_charge". Not "insufficient_credits": for old rows the cause can't be proven.
  # Returns how many rows it touched per type.
  class AbandonedCleanup
    def self.call(...)
      new(...).call
    end

    def initialize(now: Time.current)
      @now = now
    end

    def call
      Admin::ButtonRequestTypes::ALL.to_h { |klass| [klass.name, fail_abandoned(klass)] }
    end

    private

    attr_reader :now

    def fail_abandoned(klass)
      ButtonRequests::AbandonedSelection.call(klass, now:).update_all(
        status: ButtonRequests::FailureRecorder::STATUS,
        failure_reason: ButtonRequests::FailureRecorder::ABANDONED_BEFORE_CHARGE,
        updated_at: now
      )
    end
  end
end
