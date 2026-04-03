module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      class HandleImageMessage
        include Interactor::Organizer

        organize MediaGenerator::MessageHandler::ParseUserMessage,
                 MediaGenerator::MessageHandler::FindCommandRequest,
                 ValidateMessageType,
                 CreateImageMessage,
                 NotifyUser
      end
    end
  end
end
