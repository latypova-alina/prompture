require "rails_helper"

describe ScriptGenerator::GenerateRandomScriptJob do
  describe "#perform" do
    it "delegates to ScriptGenerator::GenerateRandomScript service" do
      expect(ScriptGenerator::GenerateRandomScript).to receive(:call).with(chat_id: 456)

      described_class.new.perform(456)
    end
  end
end
