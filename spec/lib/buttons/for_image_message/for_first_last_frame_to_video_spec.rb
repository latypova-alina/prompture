require "rails_helper"

describe Buttons::ForImageMessage::ForFirstLastFrameToVideo do
  subject { described_class.build(locale:) }

  let(:locale) { :en }

  it "returns provide prompt and kling 3 standard generate video buttons" do
    expect(subject).to eq(
      [
        [{ callback_data: "provide_prompt", text: "Provide Prompt" }],
        [{ callback_data: "kling_3_standard_image_to_video", text: "Kling 3 Standard (6 stones 🪨)" }]
      ]
    )
  end
end
