module ButtonRequests
  # PENDING button requests of one type that will never be processed: older than the cutoff,
  # never sent to fal and never charged. Charged PENDING requests are real stuck generations
  # and are deliberately left alone.
  class AbandonedSelection
    AGE = 1.hour

    def self.call(...)
      new(...).call
    end

    def initialize(klass, now: Time.current)
      @klass = klass
      @now = now
    end

    def call
      relation = klass.where("upper(status) = 'PENDING'").where(created_at: ...(now - AGE))
      relation = relation.where(fal_request_id: nil) if klass.column_names.include?("fal_request_id")
      relation.where.not(id: charged_ids)
    end

    private

    attr_reader :klass, :now

    def charged_ids
      BalanceTransaction.where(transaction_type: "CHARGE", source_type: klass.name).select(:source_id)
    end
  end
end
