module TelegramIntegration
  class DeleteAdminProcessingMessage
    def self.call(user: nil, chat_id: nil)
      user ||= User.find_by(chat_id:)
      return if user.blank?

      DeleteBotTelegramMessage.call(request: user)
    end
  end
end
