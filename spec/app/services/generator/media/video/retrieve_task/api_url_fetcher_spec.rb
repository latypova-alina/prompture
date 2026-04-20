require "rails_helper"

describe Generator::Media::Video::RetrieveTask::ApiUrlFetcher do
  subject(:api_url) { described_class.new(processor).api_url }

  describe "#api_url" do
    context "when processor is kling" do
      let(:processor) { "kling_2_1_pro_image_to_video" }

      it "returns kling api url" do
        expect(api_url)
          .to eq("https://api.freepik.com/v1/ai/image-to-video/kling-v2-1")
      end
    end

    context "when processor is seedance" do
      let(:processor) { "seedance_1_5_pro_image_to_video" }

      it "returns seedance api url" do
        expect(api_url)
          .to eq("https://api.freepik.com/v1/ai/video/seedance-1-5-pro-720p")
      end
    end

    context "when processor is wan" do
      let(:processor) { "wan_2_2_image_to_video" }

      it "returns wan api url" do
        expect(api_url)
          .to eq("https://api.freepik.com/v1/ai/image-to-video/wan-v2-2-720p")
      end
    end

    context "when processor is unknown" do
      let(:processor) { "unknown_processor" }

      it "returns nil" do
        expect(api_url).to be_nil
      end
    end
  end
end
