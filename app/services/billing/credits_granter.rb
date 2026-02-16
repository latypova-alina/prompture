module Billing
  class CreditsGranter < Refunder
    private

    def transaction_type
      "GRANT"
    end

    def balance
      Balance.find_or_create_by(user:) { |b| b.credits = 0 }
    end
  end
end
