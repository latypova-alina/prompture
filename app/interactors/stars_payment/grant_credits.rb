module StarsPayment
  class GrantCredits
    include Interactor

    delegate :stars_purchase, :user, :newly_recorded, to: :context
    delegate :credits_amount, to: :stars_purchase

    def call
      return unless newly_recorded

      Billing::CreditsGranter.call(user:, amount: credits_amount, source: stars_purchase)
    end
  end
end
