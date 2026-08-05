module NewUserBonusHandler
  class GrantBonus
    include Interactor
    include Memery

    CREDITS_AMOUNT = 100

    delegate :user, to: :context

    def call
      context.fail!(reason: :cap_reached) unless welcome_bonus

      Billing::CreditsGranter.call(user:, amount: CREDITS_AMOUNT, source: welcome_bonus)
    end

    private

    memoize def welcome_bonus
      WelcomeBonus.create!(user:)
    rescue ActiveRecord::StatementInvalid => e
      raise unless e.cause.is_a?(PG::CheckViolation) || e.cause.is_a?(PG::UniqueViolation)

      nil
    end
  end
end
