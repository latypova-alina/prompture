require "rails_helper"

describe MediaGenerator::MessageHandler::ImageMessageHandler::ValidateMessageType do
  subject(:result) { described_class.call(picture_id:, image_url:, width:, height:, size_bytes:) }

  let(:picture_id) { nil }
  let(:image_url) { "https://example.com/image.jpg" }
  let(:width) { 960 }
  let(:height) { 1280 }
  let(:size_bytes) { 500.kilobytes }
  let(:validator_class) { RecordValidators::CommandRequests::ImageToVideo }
  let(:validator_instance) { instance_double(validator_class) }

  before do
    allow(validator_class)
      .to receive(:new)
      .with(
        context: an_instance_of(MediaGenerator::MessageHandler::ImageMessageHandler::ValidationContext).and(
          have_attributes(
            picture_id:,
            image_url:,
            width:,
            height:,
            size_bytes:
          )
        )
      )
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
