require "rails_helper"

describe ScriptGenerator::ForCats::PerformJob do
  subject(:result) { described_class.call(chat_id: 456, template_name: "daily_news") }

  before do
    allow(ScriptGenerator::ForCats::GenerateScriptJob).to receive(:perform_async)
  end

  it "enqueues GenerateScriptJob with chat_id and template_name" do
    result

    expect(ScriptGenerator::ForCats::GenerateScriptJob).to have_received(:perform_async).with(456, "daily_news")
  end
end
