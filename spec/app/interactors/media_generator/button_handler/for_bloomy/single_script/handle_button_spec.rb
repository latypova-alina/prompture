require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::SingleScript::HandleButton do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          MediaGenerator::ButtonHandler::FindParentRequest,
          MediaGenerator::ButtonHandler::FindCommandRequest,
          MediaGenerator::ButtonHandler::ForBloomy::SingleScript::ValidateRequest,
          MediaGenerator::ButtonHandler::AcknowledgeCallbackQuery,
          MediaGenerator::ButtonHandler::ForBloomy::SingleScript::EnqueueProcess
        ]
      )
    end
  end
end
