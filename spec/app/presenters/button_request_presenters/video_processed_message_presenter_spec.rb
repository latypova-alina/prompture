require "rails_helper"

describe ButtonRequestPresenters::VideoProcessedMessagePresenter do
  subject { described_class.new(message:) }

  let(:message) { "https://example.com/video.mp4" }

  describe "#formatted_text" do
    it "returns an HTML link to the video" do
      expect(subject.formatted_text)
        .to eq("<a href=\"#{message}\">Open video</a>")
    end
  end

  describe "#inline_keyboard" do
    subject { super().inline_keyboard }

    it { is_expected.to eq([]) }
  end
end
