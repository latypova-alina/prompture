require "rails_helper"

describe ScriptGenerator::ForCats::Generate do
  describe ".call" do
    let(:message_body) { { "message" => { "text" => "/generate_cats_script daily_news" } } }

    before do
      allow(ScriptGenerator::ForCats::GenerateScriptJob).to receive(:perform_async)
    end

    it "extracts template name and enqueues job" do
      result = described_class.call(chat_id: 456, message_body:)

      expect(result).to be_success
      expect(ScriptGenerator::ForCats::GenerateScriptJob).to have_received(:perform_async).with(456, "daily_news")
    end

    it "fails when template name is missing" do
      result = described_class.call(chat_id: 456, message_body: { "message" => { "text" => "/generate_cats_script" } })

      expect(result).to be_failure
      expect(result.error).to eq(TemplateNameError)
      expect(ScriptGenerator::ForCats::GenerateScriptJob).not_to have_received(:perform_async)
    end
  end
end
