require "rails_helper"

describe MediaGenerator::ButtonHandler::HandleButton do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          MediaGenerator::ButtonHandler::FindParentRequest,
          MediaGenerator::ButtonHandler::FindCommandRequest,
          MediaGenerator::ButtonHandler::CreateRequest,
          MediaGenerator::ButtonHandler::DecrementBalance,
          MediaGenerator::ButtonHandler::NotifyProcessingStarted,
          MediaGenerator::ButtonHandler::SendGenerationTask
        ]
      )
    end
  end
end
