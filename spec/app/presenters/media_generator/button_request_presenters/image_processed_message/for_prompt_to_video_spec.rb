require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForPromptToVideo do
  subject { described_class.new(message:, balance:, processor_name:) }

  let(:message) { "https://example.com/image.png" }
  let(:balance) { 4 }
  let(:processor_name) { "Mystic image" }

  describe "#formatted_text" do
    it "returns an HTML link to the image" do
      expect(subject.formatted_text)
        .to eq(
          <<~TEXT
            Here is your #{processor_name} 🖼️

            <a href="#{message}">Open image</a>

            You can now generate a video using one of the processors (Kling)

            ────────────
            Your current balance is #{balance} credits.
          TEXT
        )
    end
  end

  describe "#inline_keyboard" do
    subject { super().inline_keyboard }

    let(:expected_buttons) do
      [
        [{ callback_data: "kling_2_1_pro_image_to_video",
           text: "Kling Pro 2.1 (10 credits)" }],
        [{ callback_data: "seedance_1_5_pro_image_to_video",
           text: "Seedance Pro 1.5 (6 credits)" }],
        [{ callback_data: "wan_2_2_image_to_video",
           text: "Wan 2.2 (8 credits)" }]
      ]
    end

    it { is_expected.to eq(expected_buttons) }
  end
end
