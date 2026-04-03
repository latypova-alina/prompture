require "rails_helper"

describe MediaGenerator::MessageHandler::ValidateMessageType do
  subject do
    described_class.call(
      message_text:,
      chat_id:,
      picture_id:,
      image_url:,
      command:
    )
  end

  let(:message_text) { "cute white kitten" }
  let(:chat_id) { 456 }
  let(:picture_id) { nil }
  let(:image_url) { nil }
  let(:command) { "prompt_to_image" }
  let(:validator_class) { RecordValidators::CommandRequests::PromptToImage }
  let(:validator_instance) { instance_double(validator_class) }

  before do
    allow(validator_class)
      .to receive(:new)
      .with(message_text:, picture_id:)
      .and_return(validator_instance)
  end

  describe "#call" do
    context "when validation succeeds" do
      before do
        allow(validator_instance).to receive(:validate)
      end

      it "succeeds" do
        result = subject

        expect(result).to be_success
      end

      it "calls validate on the validator" do
        subject

        expect(validator_instance).to have_received(:validate)
      end
    end

    context "when validator raises MessageTypeError" do
      before do
        allow(validator_instance)
          .to receive(:validate)
          .and_raise(MessageTypeError)
      end

      it "fails with MessageTypeError" do
        result = subject

        expect(result).to be_failure
        expect(result.error).to eq(MessageTypeError)
      end
    end
  end
end
