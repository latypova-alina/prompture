require "rails_helper"

describe MediaGenerator::MessageHandler::ImageMessageHandler::ValidateMessageType do
  subject(:result) { described_class.call(picture_id:, image_url:) }

  let(:picture_id) { nil }
  let(:image_url) { "https://example.com/image.jpg" }
  let(:validator_class) { RecordValidators::CommandRequests::ImageToVideo }
  let(:validator_instance) { instance_double(validator_class) }

  before do
    allow(validator_class)
      .to receive(:new)
      .with(picture_id:, image_url:)
      .and_return(validator_instance)
  end

  context "when validation succeeds" do
    before do
      allow(validator_instance).to receive(:validate)
    end

    it "succeeds" do
      expect(result).to be_success
    end

    it "calls validate on the validator" do
      result

      expect(validator_instance).to have_received(:validate)
    end
  end

  context "when validator raises MessageTypeError" do
    before do
      allow(validator_instance).to receive(:validate).and_raise(MessageTypeError)
    end

    it "fails with MessageTypeError" do
      expect(result).to be_failure
      expect(result.error).to eq(MessageTypeError)
    end
  end

  context "when validator raises ImageUrlInvalid" do
    before do
      allow(validator_instance).to receive(:validate).and_raise(ImageUrlInvalid)
    end

    it "fails with ImageUrlInvalid" do
      expect(result).to be_failure
      expect(result.error).to eq(ImageUrlInvalid)
    end
  end
end
