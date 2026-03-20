require "rails_helper"

describe MediaGenerator::MessageHandler::ModerateMessage do
  subject { described_class.call(message_text:) }

  let(:message_text) { "cute white kitten" }

  describe "#call" do
    context "when moderation flags the message" do
      before do
        allow(Moderation::OpenaiModeration)
          .to receive(:flagged?)
          .with(message_text)
          .and_return(true)
      end

      it "fails with ModerationError" do
        result = subject

        expect(result).to be_failure
        expect(result.error).to eq(ModerationError)
      end
    end

    context "when moderation does not flag the message" do
      before do
        allow(Moderation::OpenaiModeration)
          .to receive(:flagged?)
          .with(message_text)
          .and_return(false)
      end

      it "succeeds" do
        result = subject

        expect(result).to be_success
      end
    end
  end
end
