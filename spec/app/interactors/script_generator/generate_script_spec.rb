require "rails_helper"

describe ScriptGenerator::GenerateScript do
  describe ".call" do
    let(:message_body) { { "message" => { "text" => "/generate_script daily_news" } } }

    before do
      allow(ScriptGenerator::GenerateScriptJob).to receive(:perform_async)
    end

    it "extracts template name and enqueues job" do
      result = described_class.call(chat_id: 456, message_body:)

      expect(result).to be_success
      expect(ScriptGenerator::GenerateScriptJob).to have_received(:perform_async).with(456, "daily_news")
    end

    it "fails when template name is missing" do
      result = described_class.call(chat_id: 456, message_body: { "message" => { "text" => "/generate_script" } })

      expect(result).to be_failure
      expect(result.error).to eq(TemplateNameError)
      expect(ScriptGenerator::GenerateScriptJob).not_to have_received(:perform_async)
    end
  end
end
