require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForCartoonScriptEditImage do
  subject { described_class.new(message:, balance:, processor_name:, processor:) }

  let(:message) { "https://example.com/image.png" }
  let(:balance) { 8 }
  let(:processor_name) { "NanoBanana edit" }
  let(:processor) { "nano_banana_edit_image" }

  describe "#inline_keyboard" do
    subject { super().inline_keyboard }

    it "returns regenerate, regenerate script, and generate video buttons" do
      is_expected.to eq(
        [
          [{ callback_data: "nano_banana_edit_image", text: "Regenerate (1 credit)" }],
          [{ callback_data: "regenerate_single_cartoon_script_image", text: "Regenerate Script (1 credit)" }],
          [{ callback_data: "generate_cartoon_video", text: "Generate Video (5 credits)" }]
        ]
      )
    end
  end
end
