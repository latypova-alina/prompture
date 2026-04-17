require "rails_helper"

describe Generator::Media::Image::CreateTask::FluxPayloadStrategy do
  subject(:strategy) { described_class.new(prompt) }

  let(:prompt) { "little kitten" }

  describe "#payload" do
    it "returns correct static payload" do
      expect(strategy.payload).to eq(
        {
          prompt:,
          width: 768,
          height: 1440
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
