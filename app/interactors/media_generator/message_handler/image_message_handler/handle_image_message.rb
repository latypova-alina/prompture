module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      class HandleImageMessage
        include Interactor::Organizer

        organize ParseUserMessage,
                 MediaGenerator::MessageHandler::FindCommandRequest,
                 ValidateMessageType,
                 CreateImageUrlMessage,
                 CreatePictureMessage,
                 NotifyUser
      end
    end
  end
end
