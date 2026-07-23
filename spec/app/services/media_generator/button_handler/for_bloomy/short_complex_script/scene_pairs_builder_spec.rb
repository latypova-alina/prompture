require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::ShortComplexScript::ScenePairsBuilder do
  subject { described_class.new(scenes:).scene_pairs }

  let(:script) { create(:script, chained_references: true) }
  let(:scenes) do
    [
      create(:scene, script:, order: 1),
      create(:scene, script:, order: 2),
      create(:scene, script:, order: 3)
    ]
  end

  it { is_expected.to eq([[scenes[0], scenes[1]], [scenes[1], scenes[2]]]) }

  context "when scenes is blank" do
    let(:scenes) { nil }

    it { is_expected.to eq([]) }
  end
end
