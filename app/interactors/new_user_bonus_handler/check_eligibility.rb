module NewUserBonusHandler
  class CheckEligibility
    include Interactor

    delegate :user, :token_code, to: :context

    def call
      context.fail!(reason: :not_eligible) unless eligible?
    end

    private

    def eligible?
      token_code.blank? && user.previously_new_record? && Flipper.enabled?(:welcome_bonus, user)
    end
  end
end
