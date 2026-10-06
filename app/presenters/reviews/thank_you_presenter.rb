module Reviews
  # The chat message after a submitted review: a plain thank-you, or - when a reward was granted -
  # the granted amount plus the balance after the grant (separate keys, each pluralized on its own).
  class ThankYouPresenter
    def initialize(locale:, reward_credits: nil, balance: nil)
      @locale = locale
      @reward_credits = reward_credits
      @balance = balance
    end

    def text
      return I18n.t("reviews.thank_you", locale:) unless reward_credits

      [reward_line, balance_line].join("\n")
    end

    private

    attr_reader :locale, :reward_credits, :balance

    def reward_line
      I18n.t("reviews.thank_you_with_reward", credits: reward_credits, count: reward_credits, locale:)
    end

    def balance_line
      I18n.t("telegram_webhooks.commands.balance", balance:, count: balance, locale:)
    end
  end
end
