require "rails_helper"

describe RecordValidators::CommandRequests::ImageToVideo::FileValidator do
  subject(:validator) { described_class.new(picture_id:, size_bytes:) }

  let(:picture_id) { "AgACAgIAAxkBAAIB..." }

  describe "#valid?" do
    context "when picture_id is blank" do
      let(:picture_id) { nil }
      let(:size_bytes) { 500.kilobytes }

      it { expect(validator.valid?).to be(false) }
    end

    context "when size is less than 10MB" do
      let(:size_bytes) { 500.kilobytes }

      it { expect(validator.valid?).to be(true) }
    end

    context "when size is exactly 10MB" do
      let(:size_bytes) { 10.megabytes }

      it { expect(validator.valid?).to be(true) }
    end

    context "when size is greater than 10MB" do
      let(:size_bytes) { 11.megabytes }

      it { expect(validator.valid?).to be(false) }
    end
  end
end
