require "rails_helper"

describe Generator::Media::Image::CreateTask::ImagenPayloadStrategy do
  subject(:strategy) { described_class.new(prompt) }

  let(:prompt) { "Little kitten" }

  describe "#payload" do
    it "returns correct payload structure" do
      expect(strategy.payload).to eq(
        {
          prompt: prompt,
          aspect_ratio: "social_story_9_16",
          styling: {
            style: "3d"
          }
        }
      )
    end

    it "keeps the original prompt unchanged" do
      expect(strategy.payload[:prompt]).to eq(prompt)
    end
  end

  describe "#api_url" do
    it "returns the API_URL constant" do
      expect(strategy.api_url)
        .to eq(described_class::API_URL)
    end
  end
end
