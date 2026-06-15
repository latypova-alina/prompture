require "rails_helper"

RSpec.describe RecordValidators::UrlInspector::ImageUrlInspector do
  describe "#valid?" do
    subject(:valid?) { described_class.new(image_url: image_url).valid? }

    let(:image_url) { "https://example.com/image.jpg" }

    context "when url is invalid" do
      let(:image_url) { "not a valid uri" }

      it { is_expected.to be(false) }
    end

    context "when simple check fails" do
      before do
        allow(RecordValidators::UrlInspector::SimpleImageUrlValidator).to receive(:new)
          .and_return(instance_double(RecordValidators::UrlInspector::SimpleImageUrlValidator, valid?: false))
      end

      it "returns false and skips fetchability check" do
        expect(RecordValidators::UrlInspector::FetchableUrlValidator).not_to receive(:new)

        expect(valid?).to be(false)
      end
    end

    context "when simple check passes and url is fetchable" do
      before do
        allow(RecordValidators::UrlInspector::SimpleImageUrlValidator).to receive(:new)
          .and_return(instance_double(RecordValidators::UrlInspector::SimpleImageUrlValidator, valid?: true))
        allow(RecordValidators::UrlInspector::FetchableUrlValidator).to receive(:new)
          .and_return(instance_double(RecordValidators::UrlInspector::FetchableUrlValidator, valid?: true))
      end

      it { is_expected.to be(true) }
    end

    context "when simple check passes but url is not fetchable" do
      before do
        allow(RecordValidators::UrlInspector::SimpleImageUrlValidator).to receive(:new)
          .and_return(instance_double(RecordValidators::UrlInspector::SimpleImageUrlValidator, valid?: true))
        allow(RecordValidators::UrlInspector::FetchableUrlValidator).to receive(:new)
          .and_return(instance_double(RecordValidators::UrlInspector::FetchableUrlValidator, valid?: false))
      end

      it { is_expected.to be(false) }
    end
  end
end
