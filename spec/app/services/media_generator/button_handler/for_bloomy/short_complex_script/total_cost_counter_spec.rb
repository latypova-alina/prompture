require "rails_helper"

describe MediaGenerator::ButtonHandler::ForBloomy::ShortComplexScript::TotalCostCounter do
  subject { described_class.new(scene_pairs:).total_cost }

  let(:scene_pairs) { [%i[a b], %i[b c]] }

  it { is_expected.to eq(COSTS[:generate_video][:kling_3_standard_image_to_video] * 2) }
end
