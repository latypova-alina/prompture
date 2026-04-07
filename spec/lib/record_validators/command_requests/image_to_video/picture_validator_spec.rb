require "rails_helper"

describe RecordValidators::CommandRequests::ImageToVideo::PictureValidator do
  subject(:validator) { described_class.new(context:) }

  let(:context) do
    RecordValidators::CommandRequests::ImageToVideo::PictureValidationContext.new(
      picture_id:,
      width:,
      height:,
      size_bytes:
    )
  end

  let(:width) { 960 }
  let(:height) { 1280 }
  let(:size_bytes) { 500.kilobytes }

  describe "#valid?" do
    context "when picture_id is present" do
      let(:picture_id) { "AgACAgIAAxkBAAIB..." }

      it { expect(validator.valid?).to be(true) }
    end

    context "when picture_id is blank" do
      let(:picture_id) { nil }

      it { expect(validator.valid?).to be(false) }
    end

    context "when size is greater than 10MB" do
      let(:picture_id) { "AgACAgIAAxkBAAIB..." }
      let(:size_bytes) { 11.megabytes }

      it { expect(validator.valid?).to be(false) }
    end

    context "when width is less than 300px" do
      let(:picture_id) { "AgACAgIAAxkBAAIB..." }
      let(:width) { 299 }

      it { expect(validator.valid?).to be(false) }
    end

    context "when height is less than 300px" do
      let(:picture_id) { "AgACAgIAAxkBAAIB..." }
      let(:height) { 299 }

      it { expect(validator.valid?).to be(false) }
    end
  end
end
