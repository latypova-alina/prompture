module MediaGenerator
  module MessageHandler
    class HandleMessage
      include Interactor::Organizer

      organize ParseUserMessage, FindCommandRequest, ValidateMessageType, CreatePromptMessage, NotifyUser
    end
  end
end
