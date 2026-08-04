require "rails_helper"

describe Buttons::ForBloomy::GenerateComplexVideos do
  subject { described_class.build(pairs_count: 4) }

  it "builds the generate videos button with total credits" do
    expect(subject).to eq(
      [[{
        callback_data: "generate_bloomy_complex_videos",
        text: "Generate videos (24 inks 🖋️✨)"
      }]]
    )
  end
end
