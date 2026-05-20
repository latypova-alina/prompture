require "rails_helper"

describe Generator::Media::Audio::CreateTask::ElevenlabsTurboPayloadStrategy do
  subject(:strategy) { described_class.new(prompt) }

  let(:prompt) { "Hello, world!" }

  describe "#payload" do
    it "returns text and empty voice_id" do
      expect(strategy.payload).to eq(
        {
          text: prompt,
          voice_id: "IRHApOXLvnW57QJPQH2P"
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
