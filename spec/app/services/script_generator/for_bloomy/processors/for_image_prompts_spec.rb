require "rails_helper"

describe ScriptGenerator::ForBloomy::Processors::ForImagePrompts do
  subject(:process_script_image_prompts) do
    described_class.call(chat_id: 456, scenes:, reference_image_url:)
  end

  let(:scenes) { create_list(:scene, 2) }
  let(:reference_image_url) { "https://example.com/bloomy.png" }
  let(:script_processor) { instance_double(ScriptGenerator::ProcessScene::ForEditImage) }

  before do
    allow(ScriptGenerator::ProcessScene::ForEditImage).to receive(:new)
      .with(
        chat_id: 456,
        category: ContentCategory::BLOOMY_CARTOON_SCRIPT,
        reference_image_url:
      )
      .and_return(script_processor)
    allow(ScriptGenerator::ForBloomy::Processors::ForImagePrompt).to receive(:call)
  end

  it "processes each scene with a shared script processor" do
    process_script_image_prompts

    scenes.each do |scene|
      expect(ScriptGenerator::ForBloomy::Processors::ForImagePrompt).to have_received(:call).with(
        scene:,
        script_processor:
      )
    end
  end

  it "reuses the same script processor for all scenes" do
    process_script_image_prompts

    expect(ScriptGenerator::ProcessScene::ForEditImage).to have_received(:new).once
  end
end
