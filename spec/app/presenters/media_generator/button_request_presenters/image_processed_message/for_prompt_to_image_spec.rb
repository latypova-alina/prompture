require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForPromptToImage do
  subject { described_class.new(message:, balance:, processor_name:) }

  let(:message) { "https://example.com/image.png" }
  let(:balance) { 8 }
  let(:processor_name) { "Mystic image" }

  describe "#formatted_text" do
    it "returns an HTML link to the image" do
      expect(subject.formatted_text)
        .to eq(
          <<~TEXT
            Here is your #{processor_name}-generated image 🖼️

            <a href="#{message}">Open image</a>

            ────────────
            Your current balance is #{balance} credits.
          TEXT
        )
    end
  end

  describe "#inline_keyboard" do
    subject { super().inline_keyboard }

    it { is_expected.to eq([]) }
  end
end
