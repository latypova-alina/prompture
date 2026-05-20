require "rails_helper"

describe MediaGenerator::UserMessage::PromptMessagePresenter do
  subject { described_class.new(prompt_message) }

  let(:prompt_message) { create(:prompt_message, prompt:) }
  let(:prompt) { "cute white kitten" }

  describe "#formatted_text" do
    let(:expected_text) do
      <<~HTML
        <blockquote>#{prompt}</blockquote>

        #{I18n.t('telegram_webhooks.message.prompt_suffix')}
      HTML
    end

    it "returns formatted prompt text" do
      expect(subject.formatted_text).to eq(expected_text)
    end
  end

  describe "#inline_keyboard" do
    let(:expected_buttons) do
      [
        [{ callback_data: "extend_prompt", text: "Extend prompt (1 credit)" }],
        [{ callback_data: "mystic_image", text: "Mystic (2 credits)" }],
        [{ callback_data: "flux_image", text: "Flux (1 credit)" }],
        [{ callback_data: "gemini_image", text: "Gemini (1 credit)" }],
        [{ callback_data: "imagen_image", text: "Imagen (0 credits)" }]
      ]
    end

    it "builds and returns initial prompt buttons for locale" do
      expect(subject.inline_keyboard).to eq(expected_buttons)
    end
  end

  context "when command is prompt_to_audio" do
    let(:prompt_message) do
      create(:prompt_message, prompt:, command_request: create(:command_prompt_to_audio_request))
    end

    describe "#formatted_text" do
      it "returns audio prompt suffix" do
        expect(subject.formatted_text).to include(
          I18n.t("telegram_webhooks.message.prompt_suffix_audio")
        )
      end
    end

    describe "#inline_keyboard" do
      it "returns audio processor buttons" do
        expect(subject.inline_keyboard).to eq(
          [[{ callback_data: "elevenlabs_turbo_v2_5_audio", text: "ElevenLabs Turbo (2 credits)" }]]
        )
      end
    end
  end
end
