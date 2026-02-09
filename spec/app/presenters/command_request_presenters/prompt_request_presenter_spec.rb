require "rails_helper"

describe CommandRequestPresenters::PromptRequestPresenter do
  subject { described_class.new(command_request) }

  let(:prompt) { "cute white kitten" }

  let(:command_request) { create(:command_prompt_to_image_request, prompt:) }

  let(:prefix) { "Here is your prompt:" }
  let(:suffix) { "What do you want to do next?" }

  describe "#formatted_text" do
    it "returns formatted prompt message" do
      expect(subject.formatted_text).to eq(
        <<~HTML
          #{prefix}

          <blockquote>#{prompt}</blockquote>

          #{suffix}
        HTML
      )
    end
  end

  describe "#inline_keyboard" do
    it "returns initial prompt buttons" do
      expect(subject.inline_keyboard)
        .to eq(Buttons::ForInitialPromptMessage::BUTTONS)
    end
  end
end
