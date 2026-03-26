require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::VideoProcessedMessagePresenter do
  subject { described_class.new(message:, balance:) }

  let(:message) { "https://example.com/video.mp4" }
  let(:balance) { 12 }

  describe "#formatted_text" do
    it "returns an HTML link to the video" do
      expect(subject.formatted_text)
        .to eq(
          <<~TEXT
            <a href="#{message}">Open video</a>

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
