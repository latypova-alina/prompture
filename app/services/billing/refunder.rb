module Billing
  class Refunder < Base
    private

    def check_for_sufficient_funds!
      nil
    end

    def handle_balance!
      balance.increment!(:credits, amount)
    end

    def transaction_type
      "REFUND"
    end

    def create_transaction!
      BalanceTransaction.find_or_create_by!(
        user:,
        transaction_type:,
        source_type:,
        source_id:
      ) do |tx|
        tx.amount = amount
      end
    end
  end
end
