module ChatEvents
  # Which outgoing calls belong in a user's conversation history: chat-scoped methods only, never
  # infrastructure calls (setMyCommands, setWebhook, createInvoiceLink...) or the admin chat.
  class OutgoingFilter
    RECORDED_METHODS = %w[
      sendMessage sendPhoto sendVideo sendAudio sendVoice sendDocument sendAnimation sendMediaGroup sendInvoice
      editMessageText editMessageCaption editMessageReplyMarkup editMessageMedia deleteMessage answerCallbackQuery
    ].freeze

    def self.recorded_method?(action)
      RECORDED_METHODS.include?(action)
    end

    def self.recorded_chat?(chat_id)
      chat_id.present? && chat_id.to_s != ENV["ADMIN_CHAT_ID"].to_s
    end
  end
end
