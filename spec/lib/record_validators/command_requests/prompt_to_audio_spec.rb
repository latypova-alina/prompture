require "rails_helper"

describe RecordValidators::CommandRequests::PromptToAudio do
  subject(:validator) { described_class.new(message_text:, picture_id:) }

  let(:message_text) { "Hello world" }
  let(:picture_id) { nil }

  describe "#validate" do
    context "when message is text" do
      it "does not raise error" do
        expect { validator.validate }.not_to raise_error
      end
    end

    context "when message is empty" do
      let(:message_text) { "" }

      it "raises MessageTypeError" do
        expect { validator.validate }.to raise_error(MessageTypeError)
      end
    end

    context "when message is a picture" do
      let(:message_text) { nil }
      let(:picture_id) { "abc123" }

      it "raises MessageTypeError" do
        expect { validator.validate }.to raise_error(MessageTypeError)
      end
    end
  end
end
