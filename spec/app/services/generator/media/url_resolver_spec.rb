require "rails_helper"

describe Generator::Media::UrlResolver do
  subject(:resolver) { described_class.new(fal_request_id:, processor:) }

  let(:fal_request_id) { "req-123" }

  describe "#status_url" do
    context "when processor is a video processor" do
      let(:processor) { "kling_2_1_pro_image_to_video" }

      it "builds status url from video strategy api url" do
        expect(resolver.status_url).to eq(
          "https://queue.fal.run/fal-ai/kling-video/v2.1/pro/image-to-video/requests/req-123/status"
        )
      end
    end

    context "when processor is an image processor" do
      let(:processor) { "flux_image" }

      it "builds status url from image strategy api url" do
        expect(resolver.status_url).to eq(
          "https://queue.fal.run/fal-ai/flux-2-pro/requests/req-123/status"
        )
      end
    end
  end

  describe "#cancel_url" do
    let(:processor) { "flux_image" }

    it "builds cancel url from strategy api url" do
      expect(resolver.cancel_url).to eq(
        "https://queue.fal.run/fal-ai/flux-2-pro/requests/req-123/cancel"
      )
    end
  end
end
