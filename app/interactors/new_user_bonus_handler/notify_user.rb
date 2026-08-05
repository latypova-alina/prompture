module NewUserBonusHandler
  class NotifyUser
    include Interactor

    delegate :chat_id, to: :context

    def call
      ::Telegram.bot.send_message(chat_id:, text: I18n.t("telegram_webhooks.commands.start.welcome_bonus"))
    end
  end
end
