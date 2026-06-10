require "rails_helper"

describe Generator::Media::Video::CreateTask::Veo31LitePayloadStrategy do
  subject(:strategy) { described_class.new(prompt) }

  let(:prompt) { "little kitten" }

  describe "#payload" do
    it "returns payload with prompt, aspect ratio, duration, and audio flag" do
      expect(strategy.payload).to eq(
        prompt: prompt,
        aspect_ratio: "9:16",
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
