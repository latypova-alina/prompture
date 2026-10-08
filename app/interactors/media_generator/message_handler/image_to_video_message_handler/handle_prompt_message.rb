module MediaGenerator
  module MessageHandler
    module ImageToVideoMessageHandler
      class HandlePromptMessage
        include Interactor::Organizer

        organize MediaGenerator::MessageHandler::ParseUserMessage,
                 MediaGenerator::MessageHandler::FindCommandRequest,
                 ValidatePromptMessageType,
                 MediaGenerator::MessageHandler::ModerateMessage,
                 CreatePromptMessage,
                 MediaGenerator::MessageHandler::LinkModerationResult,
                 NotifyUser
      end
    end
  end
end
