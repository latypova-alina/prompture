require "rails_helper"

describe ScriptGenerator::ForBloomy::ShortComplexScript::Generator do
  describe ".call" do
    let(:scenes) { Array.new(5) { |index| "Scene #{index + 1}" } }
    let(:reference_image_url) { "https://example.com/bloomy.png" }
    let(:image_processor) { instance_double(ScriptGenerator::ProcessScene::ForEditImage) }

    before do
      allow(ScriptGenerator::ForBloomy::ShortComplexScript::SceneImagePromptCreator)
        .to receive(:call) do |scene:|
        image_prompt = create(:image_prompt, prompt: "Prompt for #{scene.scene_text}")
        scene.update!(image_prompt:)
        image_prompt
      end
      allow(ScriptGenerator::ProcessScene::ForEditImage).to receive(:new)
        .with(
          chat_id: 456,
          category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT,
          reference_image_url:
        )
        .and_return(image_processor)
      allow(image_processor).to receive(:call)
    end

    it "creates chained scenes, image prompts, and starts only the first image" do
      expect { described_class.call(chat_id: 456, scenes:, reference_image_url:) }
        .to change(Script, :count).by(1)
        .and change(Scene, :count).by(5)

      script = Script.order(:id).last
      scene_records = script.scenes

      expect(script.chained_references).to be(true)
      expect(scene_records.pluck(:scene_text)).to eq(scenes)
      expect(scene_records.pluck(:order)).to eq([1, 2, 3, 4, 5])
      expect(ScriptGenerator::ForBloomy::ShortComplexScript::SceneImagePromptCreator)
        .to have_received(:call).exactly(5).times
      expect(image_processor)
        .to have_received(:call)
        .with(image_prompt_record: scene_records.first.image_prompt)
    end
  end
end
