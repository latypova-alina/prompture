module MediaGenerator
  module ButtonHandler
    class ClearInlineKeyboard
      include Interactor

      delegate :chat_id, :tg_message_id, to: :context

      def call
        return if chat_id.blank? || tg_message_id.blank?

        Telegram.bot.edit_message_reply_markup(
          chat_id:,
          message_id: tg_message_id,
          reply_markup: { inline_keyboard: [] }
        )
      rescue Telegram::Bot::Error
        nil
      end
    end
  end
end
