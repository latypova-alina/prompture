module MediaGenerator
  module MessageHandler
    class HandleMessage
      include Interactor::Organizer

      organize ParseUserMessage, FindCommandRequest, ValidateMessageType, ValidatePromptLength, ModerateMessage,
               CreatePromptMessage, LinkModerationResult, NotifyUser
    end
  end
end
