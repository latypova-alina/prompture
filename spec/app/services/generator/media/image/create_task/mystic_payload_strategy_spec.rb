require "rails_helper"

describe Generator::Media::Image::CreateTask::MysticPayloadStrategy do
  subject(:strategy) { described_class.new(prompt) }

  let(:prompt) { "little kitten" }

  describe "#payload" do
    it "returns correct static payload" do
      expect(strategy.payload).to eq(
        {
          aspect_ratio: "social_story_9_16",
          model: "zen",
          filter_nsfw: false,
          resolution: "2k"
        }
      )
    end

    it "does not depend on prompt" do
      other_strategy = described_class.new("Something else")

      expect(strategy.payload).to eq(other_strategy.payload)
    end
  end

  describe "#api_url" do
    it "returns the API_URL constant" do
      expect(strategy.api_url)
        .to eq(described_class::API_URL)
    end
  end
end
