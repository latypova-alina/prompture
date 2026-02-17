module TokenHandler
  class GrantCredits
    include Interactor

    delegate :token, :user, to: :context
    delegate :credits, to: :token

    def call
      Billing::CreditsGranter.call(user:, amount: credits, source: token)
    end
  end
end
