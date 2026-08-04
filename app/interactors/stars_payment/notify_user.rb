module StarsPayment
  class NotifyUser
    include Interactor

    delegate :chat_id, :stars_purchase, :newly_recorded, to: :context
    delegate :credits_amount, to: :stars_purchase

    def call
      return unless newly_recorded

      ::Telegram.bot.send_message(
        chat_id:,
        text: I18n.t("telegram_webhooks.commands.buy_inks.thank_you", credits: credits_amount, count: credits_amount)
      )
    end
  end
end
