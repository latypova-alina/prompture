require "rails_helper"

describe Buttons::ForPromptMessage::ForFirstLastFrameToVideo do
  subject { described_class.build(locale:) }

  let(:locale) { :en }

  it "returns the kling 3 standard generate video button" do
    expect(subject).to eq(
      [
        [{ callback_data: "kling_3_standard_image_to_video", text: "Kling 3 Standard (9 credits)" }]
      ]
    )
  end
end
