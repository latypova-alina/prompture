require "rails_helper"

describe AudioScriptProcessor::ProcessScript do
  describe ".organized" do
    it "runs audio script processing pipeline in expected order" do
      expect(described_class.organized).to eq(
        [
          ScriptProcessor::CreatePromptMessage,
          MediaGenerator::MessageHandler::NotifyUser,
          AudioScriptProcessor::HandleAudioButton
        ]
      )
    end
  end
end
