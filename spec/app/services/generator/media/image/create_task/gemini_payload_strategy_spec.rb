require "rails_helper"

describe Generator::Media::Image::CreateTask::GeminiPayloadStrategy do
  subject(:strategy) { described_class.new(prompt) }

  let(:prompt) { "Little kitten" }

  describe "#payload" do
    it "returns payload with modified prompt and reference image" do
      expect(strategy.payload).to eq(
        {
          prompt: "Little kitten\nThe same ratio as reference image.",
          reference_images: [
            described_class::VERTICAL_IMAGE_URL
          ]
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
