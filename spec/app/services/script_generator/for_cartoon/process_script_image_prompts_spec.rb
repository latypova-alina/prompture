require "rails_helper"

describe ScriptGenerator::ForCartoon::ProcessScriptImagePrompts do
  subject(:process_script_image_prompts) do
    described_class.call(chat_id: 456, scripts:, reference_image_url:)
  end

  let(:scripts) { create_list(:script, 2) }
  let(:reference_image_url) { "https://example.com/bloomy.png" }
  let(:script_processor) { instance_double(ScriptGenerator::ProcessScript::ForEditImage) }

  before do
    allow(ScriptGenerator::ProcessScript::ForEditImage).to receive(:new)
      .with(
        chat_id: 456,
        category: ContentCategory::CARTOON_SCRIPT,
        reference_image_url:
      )
      .and_return(script_processor)
    allow(ScriptGenerator::ForCartoon::ProcessScriptImagePrompt).to receive(:call)
  end

  it "processes each script with a shared script processor" do
    process_script_image_prompts

    scripts.each do |script|
      expect(ScriptGenerator::ForCartoon::ProcessScriptImagePrompt).to have_received(:call).with(
        script:,
        script_processor:
      )
    end
  end

  it "reuses the same script processor for all scripts" do
    process_script_image_prompts

    expect(ScriptGenerator::ProcessScript::ForEditImage).to have_received(:new).once
  end
end
