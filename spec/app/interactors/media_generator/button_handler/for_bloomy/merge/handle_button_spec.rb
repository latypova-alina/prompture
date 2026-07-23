require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::Merge::HandleButton do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          MediaGenerator::ButtonHandler::FindParentRequest,
          MediaGenerator::ButtonHandler::ForBloomy::Merge::SetContext,
          MediaGenerator::ButtonHandler::FindCommandRequest,
          MediaGenerator::ButtonHandler::ForBloomy::Merge::ValidateRequest,
          MediaGenerator::ButtonHandler::AcknowledgeCallbackQuery,
          MediaGenerator::ButtonHandler::ForBloomy::Merge::CreateRequest,
          MediaGenerator::ButtonHandler::DecrementBalance,
          MediaGenerator::ButtonHandler::SendGenerationTask
        ]
      )
    end
  end
end
