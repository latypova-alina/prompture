require "rails_helper"

describe ButtonRequestPresenters::ExtendedPromptMessagePresenter do
  subject { described_class.new(message:) }

  let(:message) { "Extended prompt text" }

  describe "#formatted_text" do
    it "returns the message as formatted text" do
      expect(subject.formatted_text).to eq(message)
    end
  end

  describe "#inline_keyboard" do
    subject { super().inline_keyboard }

    it { is_expected.to eq(Buttons::ForExtendedPromptMessage::BUTTONS) }
  end
end
