require "rails_helper"

describe RecordValidators::CommandRequests::PromptToVideo do
  subject { described_class.new(message_text, 456, nil) }

  describe "#validate" do
    context "when message_text is present" do
      let(:message_text) { "cute white kitten" }

      it "does not raise an error" do
        expect { subject.validate }.not_to raise_error
      end
    end

    context "when message_text is blank" do
      let(:message_text) { nil }

      it "raises MessageTypeError" do
        expect { subject.validate }.to raise_error(MessageTypeError)
      end
    end
  end
end
