require "rails_helper"

describe UserMessagePresenters::PromptMessagePresenter do
  subject { described_class.new(prompt_message) }

  let(:prompt_message) { create(:prompt_message, prompt:) }
  let(:prompt) { "cute white kitten" }

  describe "#formatted_text" do
    let(:expected_text) do
      <<~HTML
        #{I18n.t('telegram_webhooks.message.prompt_prefix')}

        <blockquote>#{prompt}</blockquote>

        #{I18n.t('telegram_webhooks.message.prompt_suffix')}
      HTML
    end

    it "returns formatted prompt text" do
      expect(subject.formatted_text).to eq(expected_text)
    end
  end

  describe "#inline_keyboard" do
    subject { super().inline_keyboard }

    it "returns initial prompt buttons" do
      expect(subject).to eq(Buttons::ForInitialPromptMessage::BUTTONS)
    end
  end
end
