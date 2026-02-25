module SetLocale
  module ButtonHandler
    class NotifyUser
      include Interactor

      delegate :selected_locale, :chat_id, to: :context

      def call
        Telegram.bot.send_message(
          chat_id:,
          text: I18n.t("telegram_webhooks.commands.set_locale.locale_updated", locale: selected_locale)
        )
      end
    end
  end
end
