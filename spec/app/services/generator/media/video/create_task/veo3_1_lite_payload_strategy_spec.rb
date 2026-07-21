require "rails_helper"

describe Generator::Media::Video::CreateTask::Veo31LitePayloadStrategy do
  subject(:strategy) { described_class.new(prompt, button_request:) }

  let(:prompt) { "little kitten" }
  let(:button_request) { create(:button_video_processing_request, image_url: "http://example.com/image.png") }

  describe "#payload" do
    it "returns payload with prompt, image_url, aspect ratio, duration, and audio flag" do
      expect(strategy.payload).to eq(
        prompt:,
        image_url: "http://example.com/image.png",
        aspect_ratio: "auto",
        duration: 6,
        generate_audio: false
      )
    end
  end

  describe "#api_url" do
    it "returns veo 3.1 lite fal api url" do
      expect(strategy.api_url)
        .to eq("https://queue.fal.run/fal-ai/veo3.1/lite/image-to-video")
    end
  end
end
