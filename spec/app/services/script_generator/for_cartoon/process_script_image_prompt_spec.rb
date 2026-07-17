require "rails_helper"

describe ScriptGenerator::ForCartoon::ProcessScriptImagePrompt do
  subject(:process_script_image_prompt) do
    described_class.call(scene:, script_processor:)
  end

  let(:scene) { create(:scene) }
  let(:script_processor) { instance_double(ScriptGenerator::ProcessScript::ForEditImage) }
  let(:image_prompt_context) { instance_double(ScriptGenerator::ForCartoon::ImagePromptContext) }

  before do
    allow(ScriptGenerator::ForCartoon::ImagePromptContext).to receive(:new)
      .with(script_text: scene.scene_text)
      .and_return(image_prompt_context)
    allow(image_prompt_context).to receive(:prompt).and_return("Generated image prompt")
    allow(script_processor).to receive(:call)
  end

  it "creates an image prompt, links it to the scene, and processes the prompt" do
    expect { process_script_image_prompt }.to change(ImagePrompt, :count).by(1)

    scene.reload
    expect(scene.image_prompt.prompt).to eq("Generated image prompt")
    expect(script_processor).to have_received(:call).with(image_prompt_record: ImagePrompt.last)
  end

  it "fetches the image prompt from the API once" do
    process_script_image_prompt

    expect(image_prompt_context).to have_received(:prompt).once
  end
end
