module TokenHandler
  class NotifyUser
    include Interactor

    delegate :chat_id, :token, to: :context
    delegate :greeting, to: :token

    def call
      ::Telegram.bot.send_message(chat_id:, text:)
    end

    private

    def text
      return default_text unless greeting.present?

      "#{greeting}\n\n#{default_text}"
    end

    def default_text
      I18n.t("telegram_webhooks.commands.activate_token.activated", credits: token.credits)
    end
  end
end
