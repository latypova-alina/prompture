module NewUserBonusHandler
  class GrantBonus
    include Interactor
    include Memery

    CREDITS_AMOUNT = 100
    # Arbitrary fixed key for the Postgres advisory lock that serializes concurrent
    # welcome-bonus grants, so slot numbers are always assigned one at a time and no
    # eligible user loses out to a timing collision while slots remain.
    LOCK_KEY = 20_260_805_01

    delegate :user, to: :context

    def call
      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute("SELECT pg_advisory_xact_lock(#{LOCK_KEY})")

        context.fail!(reason: :cap_reached) unless welcome_bonus

        Billing::CreditsGranter.call(user:, amount: CREDITS_AMOUNT, source: welcome_bonus)
      end
    end

    private

    memoize def welcome_bonus
      WelcomeBonus.create!(user:)
    rescue ActiveRecord::StatementInvalid => e
      raise unless e.cause.is_a?(PG::CheckViolation)

      nil
    end
  end
end
