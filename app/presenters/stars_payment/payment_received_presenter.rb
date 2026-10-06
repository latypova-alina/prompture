module StarsPayment
  # "Payment received" confirmation plus the balance after the credit. Two keys joined by a newline
  # because each number needs its own pluralization (credits and balance).
  class PaymentReceivedPresenter
    def initialize(credits:, balance:, locale:)
      @credits = credits
      @balance = balance
      @locale = locale
    end

    def text
      [thank_you_line, balance_line].join("\n")
    end

    private

    attr_reader :credits, :balance, :locale

    def thank_you_line
      I18n.t("telegram_webhooks.commands.buy_stones.thank_you", credits:, count: credits, locale:)
    end

    def balance_line
      I18n.t("telegram_webhooks.commands.balance", balance:, count: balance, locale:)
    end
  end
end
