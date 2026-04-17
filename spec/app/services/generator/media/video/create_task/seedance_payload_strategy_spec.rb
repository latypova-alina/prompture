require "rails_helper"

describe Generator::Media::Video::CreateTask::SeedancePayloadStrategy do
  subject(:strategy) { described_class.new(prompt) }

  let(:prompt) { "little kitten" }

  describe "#payload" do
    it "returns payload with seedance options and prompt" do
      expect(strategy.payload).to eq(
        duration: "5",
        prompt: prompt,
        generate_audio: false,
        camera_fixed: true,
        aspect_ratio: "social_story_9_16"
      )
    end
  end

  describe "#api_url" do
    it "returns seedance api url" do
      expect(strategy.api_url)
        .to eq("https://api.freepik.com/v1/ai/video/seedance-1-5-pro-720p")
    end
  end
end
