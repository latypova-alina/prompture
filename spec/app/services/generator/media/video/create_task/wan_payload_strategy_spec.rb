require "rails_helper"

describe Generator::Media::Video::CreateTask::WanPayloadStrategy do
  subject(:strategy) { described_class.new(prompt) }

  let(:prompt) { "little kitten" }

  describe "#payload" do
    it "returns payload with wan options and prompt" do
      expect(strategy.payload).to eq(
        duration: "5",
        prompt: prompt,
        aspect_ratio: "social_story_9_16"
      )
    end
  end

  describe "#api_url" do
    it "returns wan api url" do
      expect(strategy.api_url)
        .to eq("https://api.freepik.com/v1/ai/image-to-video/wan-v2-2-720p")
    end
  end
end
