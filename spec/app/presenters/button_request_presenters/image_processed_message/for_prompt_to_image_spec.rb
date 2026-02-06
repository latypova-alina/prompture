require "rails_helper"

describe ButtonRequestPresenters::ImageProcessedMessage::ForPromptToImage do
  subject { described_class.new(message:) }

  let(:message) { "https://example.com/image.png" }

  describe "#formatted_text" do
    it "returns an HTML link to the image" do
      expect(subject.formatted_text)
        .to eq("<a href=\"#{message}\">Open image</a>")
    end
  end

  describe "#inline_keyboard" do
    subject { super().inline_keyboard }

    it { is_expected.to eq(Buttons::ForImageMessage::ForPromptToImage::BUTTONS) }
  end
end
