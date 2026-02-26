require "rails_helper"

describe MediaGenerator::MessageHandler::HandleMessage do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          MediaGenerator::MessageHandler::ParseUserMessage,
          MediaGenerator::MessageHandler::FindCommandRequest,
          MediaGenerator::MessageHandler::ValidateMessageType,
          MediaGenerator::MessageHandler::CreatePromptMessage,
          MediaGenerator::MessageHandler::NotifyUser
        ]
      )
    end
  end
end
