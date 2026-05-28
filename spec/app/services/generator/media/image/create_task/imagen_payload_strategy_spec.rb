require "rails_helper"

describe Generator::Media::Image::CreateTask::ImagenPayloadStrategy do
  subject(:strategy) { described_class.new(prompt) }

  let(:prompt) { "Little kitten" }

  describe "#payload" do
    it "returns the FAL payload" do
      expect(strategy.payload).to eq(
        {
          prompt:,
          aspect_ratio: "9:16"
        }
      )
    end
  end

  describe "#api_url" do
    it "returns the API_URL constant" do
      expect(strategy.api_url)
        .to eq(described_class::API_URL)
    end
  end
end
