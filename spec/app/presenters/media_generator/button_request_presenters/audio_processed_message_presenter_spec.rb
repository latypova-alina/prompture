require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::AudioProcessedMessagePresenter do
  subject { described_class.new(message:, balance:, processor_name:, processor:) }

  let(:message) { "https://example.com/audio.mp3" }
  let(:balance) { 12 }
  let(:processor_name) { "Adam voice" }
  let(:processor) { "elevenlabs_v3_audio" }

  describe "#formatted_text" do
    it "returns an HTML link to the audio" do
      expect(subject.formatted_text)
        .to eq(
          <<~TEXT
            Here is your #{processor_name} 🔊

            <a href="#{message}">Open audio</a>

            ────────────
            Your current balance is #{balance} credits.
          TEXT
        )
    end
  end

  describe "#inline_keyboard" do
    subject { super().inline_keyboard }

    it do
      is_expected.to eq(
        [[{ callback_data: "send_as_separate_message", text: "Send as a separate message" }]]
      )
    end
  end
end
