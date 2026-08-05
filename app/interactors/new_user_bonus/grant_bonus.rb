module NewUserBonus
  class GrantBonus
    include Interactor

    CREDITS_AMOUNT = 100

    delegate :user, to: :context

    def call
      welcome_bonus = create_welcome_bonus
      context.fail!(reason: :cap_reached) unless welcome_bonus

      Billing::CreditsGranter.call(user:, amount: CREDITS_AMOUNT, source: welcome_bonus)
    end

    private

    def create_welcome_bonus
      WelcomeBonus.create!(user:)
    rescue ActiveRecord::StatementInvalid => e
      raise unless e.cause.is_a?(PG::CheckViolation)

      nil
    end
  end
end
