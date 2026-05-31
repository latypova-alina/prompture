module MediaGenerator
  module MessageHandler
    module EditImageMessageHandler
      class HandlePromptMessage
        include Interactor::Organizer

        organize MediaGenerator::MessageHandler::ParseUserMessage,
                 MediaGenerator::MessageHandler::FindCommandRequest,
                 ValidatePromptMessageType,
                 MediaGenerator::MessageHandler::ModerateMessage,
                 SavePrompt,
                 StartGeneration,
                 NotifyProcessingStarted
      end
    end
  end
end
