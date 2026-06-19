require "rails_helper"

describe Generator::Media::CancelUrlResolver do
  subject(:resolver) { described_class.new(fal_request_id:, processor:) }

  let(:fal_request_id) { "req-123" }

  describe "#cancel_url" do
    context "when processor is flux_image" do
      let(:processor) { "flux_image" }

      it "builds cancel url from configured base url" do
        expect(resolver.cancel_url).to eq(
          "https://queue.fal.run/fal-ai/flux-2-pro/requests/req-123/cancel"
        )
      end
    end

    context "when processor is nano_banana_image" do
      let(:processor) { "nano_banana_image" }

      it "builds cancel url from configured base url" do
        expect(resolver.cancel_url).to eq(
          "https://queue.fal.run/fal-ai/nano-banana-2/requests/req-123/cancel"
        )
      end
    end

    context "when processor is nano_banana_edit_image" do
      let(:processor) { "nano_banana_edit_image" }

      it "builds cancel url from configured base url" do
        expect(resolver.cancel_url).to eq(
          "https://queue.fal.run/fal-ai/nano-banana-2/requests/req-123/cancel"
        )
      end
    end

    context "when processor is veo3_1_lite_image_to_video" do
      let(:processor) { "veo3_1_lite_image_to_video" }

      it "builds cancel url from configured base url" do
        expect(resolver.cancel_url).to eq(
          "https://queue.fal.run/fal-ai/veo3.1/requests/req-123/cancel"
        )
      end
    end

    context "when processor is kling_2_1_pro_image_to_video" do
      let(:processor) { "kling_2_1_pro_image_to_video" }

      it "builds cancel url from configured base url" do
        expect(resolver.cancel_url).to eq(
          "https://queue.fal.run/fal-ai/kling-video/requests/req-123/cancel"
        )
      end
    end

    context "when processor is hailuo_02_standard_image_to_video" do
      let(:processor) { "hailuo_02_standard_image_to_video" }

      it "builds cancel url from configured base url" do
        expect(resolver.cancel_url).to eq(
          "https://queue.fal.run/fal-ai/minimax/requests/req-123/cancel"
        )
      end
    end
  end
end
