require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::Audio::HandleButton do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          MediaGenerator::ButtonHandler::FindParentRequest,
          MediaGenerator::ButtonHandler::FindCommandRequest,
          MediaGenerator::ButtonHandler::ForBloomy::Audio::FindScene,
          MediaGenerator::ButtonHandler::AcknowledgeCallbackQuery,
          MediaGenerator::ButtonHandler::ForBloomy::Audio::CreateRequest,
          MediaGenerator::ButtonHandler::DecrementBalance,
          MediaGenerator::ButtonHandler::SendGenerationTask
        ]
      )
    end
  end
end
