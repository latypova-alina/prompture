require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForPromptToVideo do
  subject { described_class.new(message:, balance:) }

  let(:message) { "https://example.com/image.png" }
  let(:balance) { 4 }

  describe "#formatted_text" do
    it "returns an HTML link to the image" do
      expect(subject.formatted_text)
        .to eq(
          <<~TEXT
            <a href="#{message}">Open image</a>

            ────────────
            Your current balance is #{balance} credits.
          TEXT
        )
    end
  end

  describe "#inline_keyboard" do
    subject { super().inline_keyboard }

    let(:expected_buttons) do
      [[{ callback_data: "kling_2_1_pro_image_to_video",
          text: "Kling Pro 2.1 (10 credits)" }]]
    end

    it { is_expected.to eq(expected_buttons) }
  end
end
