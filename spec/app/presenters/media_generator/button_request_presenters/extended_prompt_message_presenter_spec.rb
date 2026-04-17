require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::ExtendedPromptMessagePresenter do
  subject { described_class.new(message:, balance:) }

  let(:message) { "Extended prompt text" }
  let(:balance) { 3 }

  describe "#formatted_text" do
    it "returns the message as formatted text" do
      expect(subject.formatted_text).to eq(
        <<~TEXT
          #{message}

          #{I18n.t('telegram_webhooks.message.extended_prompt_postfix')}

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
        [{ callback_data: "mystic_image", text: "Mystic (2 credits)" }],
        [{ callback_data: "flux_image", text: "Flux (1 credit)" }],
        [{ callback_data: "gemini_image", text: "Gemini (1 credit)" }],
        [{ callback_data: "imagen_image", text: "Imagen (0 credits)" }]
      ]
    end

    it { is_expected.to eq(expected_buttons) }
  end
end
