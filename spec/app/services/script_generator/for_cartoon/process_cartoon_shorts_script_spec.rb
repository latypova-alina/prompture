require "rails_helper"

describe ScriptGenerator::ForCartoon::ProcessCartoonShortsScript do
  subject(:process_cartoon_shorts_script) { described_class.call(chat_id: 456) }

  before do
    allow(ScriptGenerator::ForCartoon::ProcessSingleCartoonScript).to receive(:call)
  end

  it "delegates to ProcessSingleCartoonScript with shorts category" do
    process_cartoon_shorts_script

    expect(ScriptGenerator::ForCartoon::ProcessSingleCartoonScript).to have_received(:call).with(
      chat_id: 456,
      category: ContentCategory::CARTOON_SHORTS_SCRIPT
    )
  end
end
