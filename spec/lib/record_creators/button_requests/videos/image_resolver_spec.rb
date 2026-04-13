require "rails_helper"

describe RecordCreators::ButtonRequests::Videos::ImageResolver do
  subject(:resolver) { described_class.new(parent_request) }

  describe "#image_url" do
    context "when parent request has resolved image url" do
      let(:parent_request) { create(:button_image_processing_request, image_url: "https://example.com/image.jpg") }

      it "returns resolved image url" do
        expect(resolver.image_url).to eq("https://example.com/image.jpg")
      end
    end

    context "when parent request has no resolved image url" do
      let(:parent_request) { create(:button_image_processing_request, image_url: nil) }

      it "returns nil" do
        expect(resolver.image_url).to be_nil
      end
    end
  end
end
