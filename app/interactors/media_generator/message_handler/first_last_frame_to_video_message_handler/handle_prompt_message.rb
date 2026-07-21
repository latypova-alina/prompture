module MediaGenerator
  module MessageHandler
    module FirstLastFrameToVideoMessageHandler
      class HandlePromptMessage
        include Interactor::Organizer

        organize MediaGenerator::MessageHandler::ParseUserMessage,
                 MediaGenerator::MessageHandler::FindCommandRequest,
                 ValidatePromptMessageType,
                 MediaGenerator::MessageHandler::ModerateMessage,
                 ImageToVideoMessageHandler::CreatePromptMessage,
                 NotifyUser
      end
    end
  end
end
