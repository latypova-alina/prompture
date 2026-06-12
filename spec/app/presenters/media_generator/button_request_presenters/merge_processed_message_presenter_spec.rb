require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::MergeProcessedMessagePresenter do
  subject { described_class.new(message:, balance:, processor_name:, locale:) }

  let(:message) { "https://example.com/merged-video.mp4" }
  let(:balance) { 12 }
  let(:processor_name) { "merged cartoon video" }
  let(:locale) { :en }

  describe "#formatted_text" do
    it "returns an HTML link to the merged video" do
      expect(subject.formatted_text)
        .to eq(
          <<~TEXT
            Here is your #{processor_name} 🎬

            <a href="#{message}">Open merged video</a>

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
