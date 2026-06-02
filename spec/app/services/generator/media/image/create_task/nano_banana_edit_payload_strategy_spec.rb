require "rails_helper"

describe Generator::Media::Image::CreateTask::NanoBananaEditPayloadStrategy do
  subject(:strategy) { described_class.new(prompt) }

  let(:prompt) { "make the sky purple" }

  describe "#payload" do
    it "returns the FAL payload" do
      expect(strategy.payload).to eq(prompt:)
    end
  end

  describe "#api_url" do
    it "returns the edit API URL" do
      expect(strategy.api_url).to eq("https://queue.fal.run/fal-ai/nano-banana-2/edit")
    end
  end
end
