require "rails_helper"

describe ScriptGenerator::ForCartoon::ProcessSingleCartoonScript do
  subject(:process_single_cartoon_script) { described_class.call(chat_id: 456) }

  let(:scenes) { ["Scene 1"] }
  let(:reference_image_url) { "https://example.com/bloomy.png" }
  let(:single_cartoon_script_context) do
    instance_double(
      ScriptGenerator::ForCartoon::SingleCartoonScriptContext,
      scenes:,
      reference_image_url:
    )
  end

  before do
    allow(ScriptGenerator::ForCartoon::SingleCartoonScriptContext).to receive(:new)
      .and_return(single_cartoon_script_context)
    allow(ScriptGenerator::ForCartoon::ProcessScriptImagePrompts).to receive(:call)
  end

  it "creates a script record and processes image prompts" do
    expect { process_single_cartoon_script }.to change(Script, :count).by(1)

    script = Script.order(:id).last
    expect(script.script_text).to eq("Scene 1")
    expect(ScriptGenerator::ForCartoon::ProcessScriptImagePrompts).to have_received(:call).with(
      chat_id: 456,
      scripts: [script],
      reference_image_url:,
      category: ContentCategory::CARTOON_SCRIPT
    )
  end
end
