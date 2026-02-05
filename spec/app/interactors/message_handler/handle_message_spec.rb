require "rails_helper"

describe MessageHandler::HandleMessage do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          MessageHandler::ParseUserMessage,
          MessageHandler::SelectUpdateStrategy,
          MessageHandler::NotifyUser
        ]
      )
    end
  end
end
