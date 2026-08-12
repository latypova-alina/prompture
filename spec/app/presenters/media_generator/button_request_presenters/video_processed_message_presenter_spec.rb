require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::VideoProcessedMessagePresenter do
  subject { described_class.new(message:, balance:, processor_name:, processor:) }

  let(:message) { "https://example.com/video.mp4" }
  let(:balance) { 12 }
  let(:processor_name) { "Kling Pro video" }
  let(:processor) { "kling_2_1_pro_image_to_video" }

  describe "#formatted_text" do
    it "returns an HTML link to the video" do
      expect(subject.formatted_text)
        .to eq(
          <<~TEXT
            Here is your #{processor_name} 🎥

            ⏳ Stored for 15 days

            <a href="#{message}">Open video</a>

            ────────────
            Your current balance is #{balance} stones 🪨.
          TEXT
        )
    end
  end

  describe "#inline_keyboard" do
    subject { super().inline_keyboard }

    it do
      is_expected.to eq(
        [
          [{ callback_data: "kling_2_1_pro_image_to_video", text: "Regenerate (10 stones 🪨)" }],
          [{ callback_data: "send_as_separate_message", text: "Send as a separate message" }]
        ]
      )
    end
  end
end
