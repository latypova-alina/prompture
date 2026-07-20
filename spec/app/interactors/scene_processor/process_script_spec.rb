require "rails_helper"

describe SceneProcessor::ProcessScript do
  describe ".organized" do
    it "runs script processing pipeline in expected order" do
      expect(described_class.organized).to eq(
        [
          SceneProcessor::CreatePromptMessage,
          MediaGenerator::MessageHandler::NotifyUser,
          SceneProcessor::HandleImageGenerationButton
        ]
      )
    end
  end
end
