require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::ShortComplexScript::HandleButton do
  describe ".organized" do
    it "organizes interactors in correct order" do
      expect(described_class.organized).to eq(
        [
          MediaGenerator::ButtonHandler::FindParentRequest,
          MediaGenerator::ButtonHandler::ForBloomy::ShortComplexScript::ResolveShort,
          MediaGenerator::ButtonHandler::AcknowledgeCallbackQuery,
          MediaGenerator::ButtonHandler::ForBloomy::ShortComplexScript::CreateVideoRequests,
          MediaGenerator::ButtonHandler::ForBloomy::ShortComplexScript::DeleteCtaMessage
        ]
      )
    end
  end
end
