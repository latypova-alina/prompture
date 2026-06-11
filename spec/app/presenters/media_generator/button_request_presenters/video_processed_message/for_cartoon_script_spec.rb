require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::VideoProcessedMessage::ForCartoonScript do
  subject { described_class.new(message:, balance:, processor_name:, processor:) }

  let(:message) { "https://example.com/video.mp4" }
  let(:balance) { 12 }
  let(:processor_name) { "Veo 3.1 Lite video" }
  let(:processor) { "veo3_1_lite_image_to_video" }

  describe "#inline_keyboard" do
    subject { super().inline_keyboard }

    it "includes regenerate and generate audio buttons" do
      is_expected.to eq(
        [
          [{ callback_data: "veo3_1_lite_image_to_video", text: "Regenerate (5 credits)" }],
          [{ callback_data: "generate_cartoon_audio", text: "Generate Audio (1 credit)" }]
        ]
      )
    end
  end
end
