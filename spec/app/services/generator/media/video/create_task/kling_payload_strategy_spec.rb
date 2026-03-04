require "rails_helper"

describe Generator::Media::Video::CreateTask::KlingPayloadStrategy do
  subject(:strategy) { described_class.new(prompt) }

  let(:prompt) { "little kitten" }

  describe "#payload" do
    it "returns payload with duration, scale and prompt" do
      expect(strategy.payload).to eq(
        duration: "5",
        cfg_scale: "0.9",
        prompt: prompt
      )
    end
  end

  describe "#api_url" do
    it "returns kling api url" do
      expect(strategy.api_url)
        .to eq("https://api.freepik.com/v1/ai/image-to-video/kling-v2-1-pro")
    end
  end
end
