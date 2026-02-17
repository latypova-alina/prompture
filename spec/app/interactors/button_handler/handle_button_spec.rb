require "rails_helper"

describe ButtonHandler::HandleButton do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          ButtonHandler::FindParentRequest,
          ButtonHandler::FindCommandRequest,
          ButtonHandler::CreateRequest,
          ButtonHandler::DecrementBalance,
          ButtonHandler::SendGenerationTask
        ]
      )
    end
  end
end
