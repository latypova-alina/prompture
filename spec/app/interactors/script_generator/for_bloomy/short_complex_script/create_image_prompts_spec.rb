require "rails_helper"

describe ScriptGenerator::ForBloomy::ShortComplexScript::CreateImagePrompts do
  subject { described_class.call(scene_records:) }

  let(:script) { create(:script, chained_references: true) }
  let(:scene_records) do
    [
      create(:scene, script:, scene_text: "Scene 1", order: 1),
      create(:scene, script:, scene_text: "Scene 2", order: 2)
    ]
  end

  before do
    allow(ScriptGenerator::ForBloomy::ShortComplexScript::SceneImagePromptCreator)
      .to receive(:call)
  end

  it { is_expected.to be_success }

  it "creates an image prompt for each scene" do
    subject

    expect(ScriptGenerator::ForBloomy::ShortComplexScript::SceneImagePromptCreator)
      .to have_received(:call).with(scene: scene_records[0])
    expect(ScriptGenerator::ForBloomy::ShortComplexScript::SceneImagePromptCreator)
      .to have_received(:call).with(scene: scene_records[1])
  end
end
