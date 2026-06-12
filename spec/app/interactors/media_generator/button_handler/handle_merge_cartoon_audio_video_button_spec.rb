require "rails_helper"

describe MediaGenerator::ButtonHandler::HandleMergeCartoonAudioVideoButton do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          MediaGenerator::ButtonHandler::FindParentRequest,
          MediaGenerator::ButtonHandler::SetCartoonMergeContext,
          MediaGenerator::ButtonHandler::FindCommandRequest,
          MediaGenerator::ButtonHandler::ValidateCartoonAudioMergeRequest,
          MediaGenerator::ButtonHandler::AcknowledgeCallbackQuery,
          MediaGenerator::ButtonHandler::CreateCartoonMergeRequest,
          MediaGenerator::ButtonHandler::DecrementBalance,
          MediaGenerator::ButtonHandler::SendGenerationTask
        ]
      )
    end
  end
end
