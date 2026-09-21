require "rails_helper"

describe MediaGenerator::MessageHandler::ValidatePromptLength do
  subject { described_class.call(message_text:) }

  describe "#call" do
    context "when the prompt is within the allowed length" do
      let(:message_text) { "cute white kitten" }

      it "succeeds" do
        result = subject

        expect(result).to be_success
      end
    end

    context "when the prompt exceeds the allowed length" do
      let(:message_text) { "a" * (described_class::MAX_LENGTH + 1) }

      it "fails with PromptTooLongError" do
        result = subject

        expect(result).to be_failure
        expect(result.error).to eq(PromptTooLongError)
      end
    end

    context "when the prompt is exactly at the allowed length" do
      let(:message_text) { "a" * described_class::MAX_LENGTH }

      it "succeeds" do
        result = subject

        expect(result).to be_success
      end
    end
  end
end
