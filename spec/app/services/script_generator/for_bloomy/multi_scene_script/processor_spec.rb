require "rails_helper"

describe ScriptGenerator::ForBloomy::MultiSceneScript::Processor do
  subject(:process_cartoon_script) { described_class.call(chat_id: 456) }

  let(:scenes) { Array.new(12) { |index| "Scene #{index + 1}" } }
  let(:reference_image_url) { "https://example.com/bloomy.png" }
  let(:context) do
    instance_double(
      ScriptGenerator::ForBloomy::MultiSceneScript::Context,
      scenes:,
      reference_image_url:
    )
  end

  before do
    allow(ScriptGenerator::ForBloomy::MultiSceneScript::Context).to receive(:new)
      .and_return(context)
    allow(ScriptGenerator::ForBloomy::Processors::ForImagePrompts).to receive(:call)
  end

  it "creates a scene record for each scene and processes image prompts" do
    expect { process_cartoon_script }
      .to change(Scene, :count).by(12)
      .and change(Script, :count).by(1)

    script = Script.order(:id).last
    scene_records = script.scenes
    expect(script.chained_references).to be(false)
    expect(scene_records.pluck(:scene_text)).to eq(scenes)
    expect(scene_records.pluck(:order)).to eq((1..12).to_a)
    expect(ScriptGenerator::ForBloomy::Processors::ForImagePrompts).to have_received(:call).with(
      chat_id: 456,
      scenes: scene_records,
      reference_image_url:
    )
  end
end
