require "rails_helper"

describe ScriptGenerator::ForBloomy::ShortComplexScript::GenerateFirstImage do
  subject do
    described_class.call(
      chat_id: 456,
      reference_image_url:,
      scene_records:
    )
  end

  let(:reference_image_url) { "https://example.com/bloomy.png" }
  let(:script) { create(:script, chained_references: true) }
  let(:image_prompt) { create(:image_prompt) }
  let(:first_scene) { create(:scene, script:, scene_text: "Scene 1", order: 1, image_prompt:) }
  let(:scene_records) do
    [
      first_scene,
      create(:scene, script:, scene_text: "Scene 2", order: 2)
    ]
  end
  let(:image_processor) { instance_double(ScriptGenerator::ProcessScene::ForEditImage) }

  before do
    allow(ScriptGenerator::ProcessScene::ForEditImage).to receive(:new)
      .with(
        chat_id: 456,
        category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT,
        reference_image_url:
      )
      .and_return(image_processor)
    allow(image_processor).to receive(:call)
  end

  it { is_expected.to be_success }

  it "starts image generation for the first scene only" do
    subject

    expect(image_processor).to have_received(:call).with(image_prompt_record: image_prompt)
  end

  context "when scene_records are empty" do
    let(:scene_records) { [] }

    it "does not start image generation" do
      subject

      expect(ScriptGenerator::ProcessScene::ForEditImage).not_to have_received(:new)
    end
  end
end
