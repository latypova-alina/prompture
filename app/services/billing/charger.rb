module Billing
  class Charger < Base
    private

    def check_for_sufficient_funds!
      raise InsufficientCreditsError if balance.credits < amount
    end

    def handle_balance!
      balance.decrement!(:credits, amount)
    end

    def create_transaction!
      BalanceTransaction.find_or_create_by!(
        user:,
        transaction_type: "CHARGE",
        source_type:,
        source_id:
      ) do |tx|
        tx.amount = -amount
      end
    end
  end
end
