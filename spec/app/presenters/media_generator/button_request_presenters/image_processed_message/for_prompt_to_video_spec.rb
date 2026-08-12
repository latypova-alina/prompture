require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForPromptToVideo do
  subject { described_class.new(message:, balance:, processor_name:, processor:) }

  let(:message) { "https://example.com/image.png" }
  let(:balance) { 4 }
  let(:processor_name) { "Flux image" }
  let(:processor) { "flux_image" }

  describe "#formatted_text" do
    it "returns an HTML link to the image" do
      expect(subject.formatted_text)
        .to eq(
          <<~TEXT
            Here is your #{processor_name} 🖼️

            ⏳ Stored for 15 days

            <a href="#{message}">Open image</a>

            You can now generate a video using one of the options below.

            ────────────
            Your current balance is #{balance} stones 🪨.
          TEXT
        )
    end
  end

  describe "#inline_keyboard" do
    subject { super().inline_keyboard }

    let(:expected_buttons) do
      [
        [{ callback_data: "flux_image",
           text: "Regenerate (1 stone 🪨)" }],
        [{ callback_data: "kling_2_1_pro_image_to_video",
           text: "Kling Pro 2.1 (10 stones 🪨)" }],
        [{ callback_data: "hailuo_02_standard_image_to_video",
           text: "Hailuo 02 Standard (6 stones 🪨)" }],
        [{ callback_data: "veo3_1_lite_image_to_video",
           text: "Veo 3.1 Lite (5 stones 🪨)" }],
        [{ callback_data: "send_as_separate_message", text: "Send as a separate message" }]
      ]
    end

    it { is_expected.to eq(expected_buttons) }
  end
end
