module StoreImage
  class ErrorNotifierJob < BaseNotifierJob
    include ErrorI18nResolver

    private

    delegate :chat_id, :tg_message_id, to: :image_record

    def notify
      Telegram.bot.send_message(**message_data)
    end

    def message_data
      {
        chat_id:,
        text: I18n.t(error_i18n_key(error_class_name)),
        reply_to_message_id: tg_message_id
      }.compact
    end
  end
end
