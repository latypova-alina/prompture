require "rails_helper"

describe RecordValidators::CommandRequests::ImageToVideo::PictureValidator do
  subject(:validator) { described_class.new(picture_id:) }

  describe "#valid?" do
    context "when picture_id is present" do
      let(:picture_id) { "AgACAgIAAxkBAAIB..." }

      it { expect(validator.valid?).to be(true) }
    end

    context "when picture_id is blank" do
      let(:picture_id) { nil }

      it { expect(validator.valid?).to be(false) }
    end
  end
end
