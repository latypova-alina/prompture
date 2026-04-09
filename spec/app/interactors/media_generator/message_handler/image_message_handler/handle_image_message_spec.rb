require "rails_helper"

describe MediaGenerator::MessageHandler::ImageMessageHandler::HandleImageMessage do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          MediaGenerator::MessageHandler::ImageMessageHandler::ParseUserMessage,
          MediaGenerator::MessageHandler::FindCommandRequest,
          MediaGenerator::MessageHandler::ImageMessageHandler::ValidateMessageType,
          MediaGenerator::MessageHandler::ImageMessageHandler::CreateImageUrlMessage,
          MediaGenerator::MessageHandler::ImageMessageHandler::CreatePictureMessage,
          MediaGenerator::MessageHandler::ImageMessageHandler::EnqueueStoreImageJob,
          MediaGenerator::MessageHandler::ImageMessageHandler::NotifyUser
        ]
      )
    end
  end
end
