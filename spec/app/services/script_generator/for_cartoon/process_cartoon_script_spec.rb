require "rails_helper"

describe ScriptGenerator::ForCartoon::ProcessCartoonScript do
  subject(:process_cartoon_script) { described_class.call(chat_id: 456) }

  let(:scenes) { Array.new(12) { |index| "Scene #{index + 1}" } }
  let(:reference_image_url) { "https://example.com/bloomy.png" }
  let(:cartoon_script_context) do
    instance_double(
      ScriptGenerator::ForCartoon::CartoonScriptContext,
      scenes:,
      reference_image_url:
    )
  end

  before do
    allow(ScriptGenerator::ForCartoon::CartoonScriptContext).to receive(:new)
      .and_return(cartoon_script_context)
    allow(ScriptGenerator::ForCartoon::ProcessScriptImagePrompts).to receive(:call)
  end

  it "creates a script record for each scene and processes image prompts" do
    expect { process_cartoon_script }.to change(Script, :count).by(12)

    scripts = Script.order(:id).last(12)
    expect(scripts.pluck(:script_text)).to eq(scenes)
    expect(ScriptGenerator::ForCartoon::ProcessScriptImagePrompts).to have_received(:call).with(
      chat_id: 456,
      scripts:,
      reference_image_url:
    )
  end
end
