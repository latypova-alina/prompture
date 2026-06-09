require "rails_helper"

describe Generator::Media::Video::CreateTask::Hailuo02StandardPayloadStrategy do
  subject(:strategy) { described_class.new(prompt) }

  let(:prompt) { "little kitten" }

  describe "#payload" do
    it "returns payload with duration and prompt" do
      expect(strategy.payload).to eq(
        prompt: prompt,
        duration: 6
      )
    end
  end

  describe "#api_url" do
    it "returns hailuo 02 standard fal api url" do
      expect(strategy.api_url)
        .to eq("https://queue.fal.run/fal-ai/minimax/hailuo-02/standard/image-to-video")
    end
  end
end
