require "rails_helper"

describe ScriptProcessor::ProcessScript do
  describe ".organized" do
    it "runs script processing pipeline in expected order" do
      expect(described_class.organized).to eq(
        [
          ScriptProcessor::CreatePromptMessage,
          MediaGenerator::MessageHandler::NotifyUser,
          ScriptProcessor::HandleFluxButton
        ]
      )
    end
  end
end
