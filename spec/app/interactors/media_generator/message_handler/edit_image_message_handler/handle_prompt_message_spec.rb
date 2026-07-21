require "rails_helper"

describe MediaGenerator::MessageHandler::EditImageMessageHandler::HandlePromptMessage do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          MediaGenerator::MessageHandler::ParseUserMessage,
          MediaGenerator::MessageHandler::FindCommandRequest,
          MediaGenerator::MessageHandler::EditImageMessageHandler::ValidatePromptMessageType,
          MediaGenerator::MessageHandler::ModerateMessage,
          MediaGenerator::MessageHandler::EditImageMessageHandler::SavePrompt,
          MediaGenerator::MessageHandler::EditImageMessageHandler::StartGeneration
        ]
      )
    end
  end
end
