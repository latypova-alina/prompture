require "rails_helper"

describe RecordValidators::CommandRequests::ImageToVideo do
  subject(:validator) { described_class.new(picture_id:, image_url:) }

  describe "#validate" do
    context "when image_url is valid" do
      let(:picture_id) { nil }
      let(:image_url) { "https://example.com/image.jpg" }

      before do
        allow_any_instance_of(described_class::ImageUrlValidator).to receive(:valid?).and_return(true)
        allow_any_instance_of(described_class::ImageUrlValidator).to receive(:invalid?).and_return(false)
      end

      it "does not raise an error" do
        expect { validator.validate }.not_to raise_error
      end
    end

    context "when image_url is invalid" do
      let(:picture_id) { nil }
      let(:image_url) { "https://example.com/image.jpg" }

      before do
        allow_any_instance_of(described_class::ImageUrlValidator).to receive(:invalid?).and_return(true)
      end

      it "raises ImageUrlInvalid" do
        expect { validator.validate }.to raise_error(ImageUrlInvalid)
      end
    end

    context "when neither image_url nor picture_id is provided" do
      let(:picture_id) { nil }
      let(:image_url) { nil }

      it "raises MessageTypeError" do
        expect { validator.validate }.to raise_error(MessageTypeError)
      end
    end

    context "when picture_id is present and image_url is blank" do
      let(:picture_id) { "AgACAgIAAxkBAAIB..." }
      let(:image_url) { nil }

      it "does not raise an error" do
        expect { validator.validate }.not_to raise_error
      end
    end
  end
end
