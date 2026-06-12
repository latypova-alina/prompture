require "rails_helper"

describe MediaGenerator::ButtonHandler::HandleRegenerateSingleCartoonScriptImageButton do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          MediaGenerator::ButtonHandler::FindParentRequest,
          MediaGenerator::ButtonHandler::FindCommandRequest,
          MediaGenerator::ButtonHandler::ValidateCartoonScriptImageRequest,
          MediaGenerator::ButtonHandler::AcknowledgeCallbackQuery,
          MediaGenerator::ButtonHandler::EnqueueSingleCartoonScriptProcess
        ]
      )
    end
  end
end
