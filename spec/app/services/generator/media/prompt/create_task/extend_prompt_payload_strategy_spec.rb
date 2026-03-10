require "rails_helper"

describe Generator::Media::Prompt::CreateTask::ExtendPromptPayloadStrategy do
  subject(:strategy) { described_class.new(prompt) }

  let(:prompt) { "a short prompt" }

  describe "#payload" do
    it "returns payload containing prompt" do
      expect(strategy.payload).to eq({ prompt:, type: "image" })
    end
  end

  describe "#api_url" do
    it "returns API_URL constant" do
      expect(strategy.api_url).to eq(described_class::API_URL)
    end
  end
end
