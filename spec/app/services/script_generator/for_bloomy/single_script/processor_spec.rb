require "rails_helper"

describe ScriptGenerator::ForBloomy::SingleScript::Processor do
  subject(:process_single_cartoon_script) { described_class.call(chat_id: 456) }

  let(:scenes) { ["Scene 1"] }
  let(:reference_image_url) { "https://example.com/bloomy.png" }
  let(:context) do
    instance_double(
      ScriptGenerator::ForBloomy::SingleScript::Context,
      scenes:,
      reference_image_url:
    )
  end

  before do
    allow(ScriptGenerator::ForBloomy::SingleScript::Context).to receive(:new)
      .and_return(context)
    allow(ScriptGenerator::ForBloomy::Processors::ForImagePrompts).to receive(:call)
  end

  it "creates a scene record and processes image prompts" do
    expect { process_single_cartoon_script }
      .to change(Scene, :count).by(1)
      .and change(Script, :count).by(1)

    scene = Scene.order(:id).last
    expect(scene.scene_text).to eq("Scene 1")
    expect(scene.order).to eq(1)
    expect(scene.script.chained_references).to be(false)
    expect(ScriptGenerator::ForBloomy::Processors::ForImagePrompts).to have_received(:call).with(
      chat_id: 456,
      scenes: [scene],
      reference_image_url:,
      category: ContentCategory::BLOOMY_CARTOON_SCRIPT
    )
  end
end
