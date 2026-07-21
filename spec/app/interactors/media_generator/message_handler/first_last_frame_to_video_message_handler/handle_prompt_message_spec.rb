require "rails_helper"

describe MediaGenerator::MessageHandler::FirstLastFrameToVideoMessageHandler::HandlePromptMessage do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          MediaGenerator::MessageHandler::ParseUserMessage,
          MediaGenerator::MessageHandler::FindCommandRequest,
          MediaGenerator::MessageHandler::FirstLastFrameToVideoMessageHandler::ValidatePromptMessageType,
          MediaGenerator::MessageHandler::ModerateMessage,
          MediaGenerator::MessageHandler::ImageToVideoMessageHandler::CreatePromptMessage,
          MediaGenerator::MessageHandler::FirstLastFrameToVideoMessageHandler::NotifyUser
        ]
      )
    end
  end
end
