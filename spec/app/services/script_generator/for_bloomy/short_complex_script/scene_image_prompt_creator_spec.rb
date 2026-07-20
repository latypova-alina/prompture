require "rails_helper"

describe ScriptGenerator::ForBloomy::ShortComplexScript::SceneImagePromptCreator do
  subject(:create_scene_image_prompt) { described_class.call(scene:) }

  let(:scene) { create(:scene) }
  let(:image_prompt_context) { instance_double(ScriptGenerator::ForBloomy::SharedContexts::ForImagePrompt) }

  before do
    allow(ScriptGenerator::ForBloomy::SharedContexts::ForImagePrompt).to receive(:new)
      .with(script_text: scene.scene_text)
      .and_return(image_prompt_context)
    allow(image_prompt_context).to receive(:prompt).and_return("Generated image prompt")
  end

  it "creates an image prompt and links it to the scene" do
    expect { create_scene_image_prompt }.to change(ImagePrompt, :count).by(1)

    expect(scene.reload.image_prompt.prompt).to eq("Generated image prompt")
    expect(create_scene_image_prompt).to eq(ImagePrompt.last)
  end
end
