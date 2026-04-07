require "rails_helper"

describe RecordValidators::CommandRequests::ImageToVideo::ImageUrlValidator do
  subject(:validator) { described_class.new(image_url:) }

  describe "#valid?" do
    context "when image_url is blank" do
      let(:image_url) { nil }

      it { expect(validator.valid?).to be(false) }
    end

    context "when image_url is present and inspector returns true" do
      let(:image_url) { "https://example.com/image.jpg" }

      before do
        allow_any_instance_of(RecordValidators::UrlInspector::ImageUrlInspector).to receive(:valid?).and_return(true)
      end

      it { expect(validator.valid?).to be(true) }
    end

    context "when image_url is present and inspector returns false" do
      let(:image_url) { "https://example.com/image.jpg" }

      before do
        allow_any_instance_of(RecordValidators::UrlInspector::ImageUrlInspector).to receive(:valid?).and_return(false)
      end

      it { expect(validator.valid?).to be(false) }
    end
  end

  describe "#invalid?" do
    context "when image_url is blank" do
      let(:image_url) { nil }

      it { expect(validator.invalid?).to be(false) }
    end

    context "when image_url is present and inspector returns false" do
      let(:image_url) { "https://example.com/image.jpg" }

      before do
        allow_any_instance_of(RecordValidators::UrlInspector::ImageUrlInspector).to receive(:valid?).and_return(false)
      end

      it { expect(validator.invalid?).to be(true) }
    end
  end
end
