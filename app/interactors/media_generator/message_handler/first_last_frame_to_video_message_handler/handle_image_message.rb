module MediaGenerator
  module MessageHandler
    module FirstLastFrameToVideoMessageHandler
      class HandleImageMessage
        include Interactor::Organizer

        organize ImageMessageHandler::ParseUserMessage,
                 MediaGenerator::MessageHandler::FindCommandRequest,
                 ValidateMessageType,
                 ImageMessageHandler::CreateImageUrlMessage,
                 ImageMessageHandler::CreatePictureMessage,
                 ImageMessageHandler::CreateFileMessage,
                 ImageMessageHandler::EnqueueStoreImageJob
      end
    end
  end
end
