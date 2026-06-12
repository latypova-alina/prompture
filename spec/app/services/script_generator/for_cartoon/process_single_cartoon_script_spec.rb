require "rails_helper"

describe ScriptGenerator::ForCartoon::ProcessSingleCartoonScript do
  subject(:process_single_cartoon_script) { described_class.call(chat_id: 456) }

  let(:scenes_array) { ["Scene A", "Scene B", "Scene C"] }
  let(:reference_image_url) { "https://example.com/bloomy.png" }
  let(:cartoon_script_context) do
    instance_double(
      ScriptGenerator::ForCartoon::CartoonScriptContext,
      reference_image_url:
    )
  end

  before do
    allow(ScriptGenerator::ForCartoon::CartoonScriptContext).to receive(:new)
      .and_return(cartoon_script_context)
    allow(cartoon_script_context).to receive(:scenes).and_return(scenes_array)
    allow(scenes_array).to receive(:sample).and_return("Scene B")
    allow(ScriptGenerator::ForCartoon::ProcessScriptImagePrompts).to receive(:call)
  end

  it "creates one script from a random scene and processes image prompts" do
    expect { process_single_cartoon_script }.to change(Script, :count).by(1)

    script = Script.order(:id).last
    expect(script.script_text).to eq("Scene B")
    expect(ScriptGenerator::ForCartoon::ProcessScriptImagePrompts).to have_received(:call).with(
      chat_id: 456,
      scripts: [script],
      reference_image_url:
    )
  end
end
