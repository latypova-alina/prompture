require "rails_helper"

describe ScriptGenerator::ForBloomy::GenerateVideosCta::PairsCount do
  subject { described_class.new(scenes:).pairs_count }

  let(:script) { create(:script, chained_references: true) }
  let!(:scenes) do
    [
      create(:scene, script:, order: 1),
      create(:scene, script:, order: 2),
      create(:scene, script:, order: 3)
    ]
  end

  it { is_expected.to eq(2) }

  context "when there is only one scene" do
    let!(:scenes) { [create(:scene, script:, order: 1)] }

    it { is_expected.to eq(0) }
  end
end
