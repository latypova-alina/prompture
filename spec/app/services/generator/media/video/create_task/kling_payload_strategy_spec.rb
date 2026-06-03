require "rails_helper"

describe Generator::Media::Video::CreateTask::KlingPayloadStrategy do
  subject(:strategy) { described_class.new(prompt) }

  let(:prompt) { "little kitten" }

  describe "#payload" do
    it "returns payload with duration and prompt" do
      expect(strategy.payload).to eq(
        prompt: prompt,
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
