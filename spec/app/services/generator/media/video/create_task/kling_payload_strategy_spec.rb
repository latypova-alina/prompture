require "rails_helper"

describe Generator::Media::Video::CreateTask::KlingPayloadStrategy do
  subject(:strategy) { described_class.new(prompt, button_request:) }

  let(:prompt) { "little kitten" }
  let(:button_request) { create(:button_video_processing_request, image_url: "http://example.com/image.png") }

  describe "#payload" do
    it "returns payload with duration, prompt, and image_url" do
      expect(strategy.payload).to eq(
        prompt:,
        image_url: "http://example.com/image.png",
        duration: 5
      )
    end
  end

  describe "#api_url" do
    it "returns kling fal api url" do
      expect(strategy.api_url)
        .to eq("https://queue.fal.run/fal-ai/kling-video/v2.1/pro/image-to-video")
    end
  end
end
