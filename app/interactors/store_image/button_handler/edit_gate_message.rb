module StoreImage
  module ButtonHandler
    class EditGateMessage
      include Interactor

      delegate :chat_id, :tg_message_id, :user, to: :context

      def call
        Telegram.bot.edit_message_text(
          chat_id:,
          message_id: tg_message_id,
          text: I18n.t("telegram_webhooks.message.terms_gate.accepted", locale: user.locale),
          reply_markup: { inline_keyboard: [] }
        )
      end
    end
  end
end
