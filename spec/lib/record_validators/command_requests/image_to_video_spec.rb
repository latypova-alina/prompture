require "rails_helper"
require "ostruct"

describe RecordValidators::CommandRequests::ImageToVideo do
  subject(:validator) { described_class.new(context:) }

  let(:context) do
    OpenStruct.new(
      picture_id:,
      image_url:,
      width:,
      height:,
      size_bytes:
    )
  end
  let(:width) { nil }
  let(:height) { nil }
  let(:size_bytes) { nil }
  let(:image_url_validator) { instance_double(described_class::ImageUrlValidator, valid?: image_url_valid, invalid?: image_url_invalid) }
  let(:picture_validator) { instance_double(described_class::PictureValidator, valid?: picture_valid) }
  let(:image_url_valid) { false }
  let(:image_url_invalid) { false }
  let(:picture_valid) { false }

  before do
    allow(described_class::ImageUrlValidator)
      .to receive(:new)
      .with(image_url:)
      .and_return(image_url_validator)

    allow(described_class::PictureValidator)
      .to receive(:new)
      .with(
        context: an_instance_of(described_class::PictureValidationContext).and(
          have_attributes(
            picture_id:,
            width:,
            height:,
            size_bytes:
          )
        )
      )
      .and_return(picture_validator)
  end

  describe "#validate" do
    context "when image_url is valid" do
      let(:picture_id) { nil }
      let(:image_url) { "https://example.com/image.jpg" }
      let(:image_url_valid) { true }

      it "does not raise an error" do
        expect { validator.validate }.not_to raise_error
      end
    end

    context "when image_url is invalid" do
      let(:picture_id) { nil }
      let(:image_url) { "https://example.com/image.jpg" }
      let(:image_url_invalid) { true }
      let(:picture_valid) { true }

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
      let(:width) { 960 }
      let(:height) { 1280 }
      let(:size_bytes) { 500.kilobytes }
      let(:picture_valid) { true }

      it "does not raise an error" do
        expect { validator.validate }.not_to raise_error
      end
    end
  end
end
