require "rails_helper"

describe Generator::Media::Video::CreateTask::SeedancePayloadStrategy do
  subject(:strategy) { described_class.new(prompt) }

  let(:prompt) { "little kitten" }

  describe "#payload" do
    it "returns payload with duration, prompt, aspect ratio, and audio flag" do
      expect(strategy.payload).to eq(
        prompt: prompt,
        duration: 5,
        aspect_ratio: "9:16",
        generate_audio: false
      )
    end
  end

  describe "#api_url" do
    it "returns seedance fal api url" do
      expect(strategy.api_url)
        .to eq("https://queue.fal.run/bytedance/seedance-2.0/image-to-video")
    end
  end
end
