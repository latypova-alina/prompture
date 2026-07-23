require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::MultiSceneScript::HandleButton do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          MediaGenerator::ButtonHandler::FindParentRequest,
          MediaGenerator::ButtonHandler::FindCommandRequest,
          MediaGenerator::ButtonHandler::ForBloomy::MultiSceneScript::FindScene,
          MediaGenerator::ButtonHandler::AcknowledgeCallbackQuery,
          MediaGenerator::ButtonHandler::ForBloomy::MultiSceneScript::CreateVideoRequest,
          MediaGenerator::ButtonHandler::DecrementBalance,
          MediaGenerator::ButtonHandler::SendGenerationTask
        ]
      )
    end
  end
end
