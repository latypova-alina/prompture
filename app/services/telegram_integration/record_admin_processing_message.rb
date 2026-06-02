module TelegramIntegration
  class RecordAdminProcessingMessage
    def self.call(response:, user:)
      return if user.blank?

      DeleteBotTelegramMessage.call(request: user)
      RecordBotTelegramMessage.call(response:, request: user)
    end
  end
end
