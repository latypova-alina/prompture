module TokenHandler
  class NotifyUser
    include Interactor

    delegate :chat_id, :token, to: :context
    delegate :greeting, to: :token

    def call
      ::Telegram.bot.send_message(chat_id:, text: greeting || t("telegram_webhooks.commands.start"))
    end
  end
end
