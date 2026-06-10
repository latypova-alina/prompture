require "rails_helper"

describe ScriptGenerator::ForCartoon::ProcessScriptImagePrompt do
  subject(:process_script_image_prompt) do
    described_class.call(script:, script_processor:)
  end

  let(:script) { create(:script) }
  let(:script_processor) { instance_double(ScriptGenerator::ProcessScript::ForEditImage) }
  let(:image_prompt_context) { instance_double(ScriptGenerator::ForCartoon::ImagePromptContext) }

  before do
    allow(ScriptGenerator::ForCartoon::ImagePromptContext).to receive(:new)
      .with(script_text: script.script_text)
      .and_return(image_prompt_context)
    allow(image_prompt_context).to receive(:image_prompt).and_return("Generated image prompt")
    allow(script_processor).to receive(:call)
  end

  it "creates an image prompt, links it to the script, and processes the prompt" do
    expect { process_script_image_prompt }.to change(ImagePrompt, :count).by(1)

    script.reload
    expect(script.image_prompt.prompt).to eq("Generated image prompt")
    expect(script_processor).to have_received(:call).with(script: "Generated image prompt")
  end

  it "fetches the image prompt from the API once" do
    process_script_image_prompt

    expect(image_prompt_context).to have_received(:image_prompt).once
  end
end
