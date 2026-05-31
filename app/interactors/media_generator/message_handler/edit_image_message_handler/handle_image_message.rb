module MediaGenerator
  module MessageHandler
    module EditImageMessageHandler
      class HandleImageMessage
        include Interactor::Organizer

        organize ImageMessageHandler::ParseUserMessage,
                 MediaGenerator::MessageHandler::FindCommandRequest,
                 ValidateImageMessageType,
                 ImageMessageHandler::CreateImageUrlMessage,
                 ImageMessageHandler::CreatePictureMessage,
                 ImageMessageHandler::EnqueueStoreImageJob
      end
    end
  end
end
