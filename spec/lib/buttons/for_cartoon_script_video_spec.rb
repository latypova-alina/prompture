require "rails_helper"

describe Buttons::ForCartoonScriptVideo do
  subject(:result) { described_class.build(locale:, processor:) }

  let(:locale) { :en }
  let(:processor) { "veo3_1_lite_image_to_video" }

  it "builds regenerate and generate audio buttons" do
    expect(result).to eq(
      [
        [{ callback_data: "veo3_1_lite_image_to_video", text: "Regenerate (5 credits)" }],
        [{ callback_data: "generate_cartoon_audio", text: "Generate Audio (1 credit)" }]
      ]
    )
  end
end
