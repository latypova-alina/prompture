require "rails_helper"

describe ScriptGenerator::ForBloomy::ShortComplexScript::ExtractSceneRecords do
  subject { described_class.call(scenes:) }

  let(:scenes) { ["Scene 1", "Scene 2"] }

  it { is_expected.to be_success }

  it "creates a chained script with ordered scenes" do
    expect { subject }
      .to change(Script, :count).by(1)
      .and change(Scene, :count).by(2)

    script = Script.order(:id).last

    expect(script.chained_references).to be(true)
    expect(subject.scene_records.pluck(:scene_text)).to eq(scenes)
    expect(subject.scene_records.pluck(:order)).to eq([1, 2])
  end
end
