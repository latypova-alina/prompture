module StarsPayment
  class NotifyUser
    include Interactor
    include Memery

    delegate :chat_id, :user, :locale, :stars_purchase, :newly_recorded, to: :context
    delegate :credits_amount, to: :stars_purchase
    delegate :text, to: :presenter

    def call
      return unless newly_recorded

      ::Telegram.bot.send_message(chat_id:, text:)
    end

    private

    memoize def presenter
      StarsPayment::PaymentReceivedPresenter.new(credits: credits_amount, balance: current_balance, locale:)
    end

    # Read fresh after GrantCredits - the cached user.balance may predate the credit (or not exist yet).
    def current_balance
      Balance.find_by!(user:).credits
    end
  end
end
