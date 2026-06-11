require "rails_helper"

describe Generator::Media::Audio::CreateTask::ElevenlabsV3PayloadStrategy do
  subject(:strategy) { described_class.new(prompt, voice_id) }

  let(:prompt) { "Hi, my name is Bloomy." }
  let(:voice_id) { "ocZQ262SsZb9RIxcQBOj" }

  describe "#payload" do
    it "returns text and voice for fal eleven-v3" do
      expect(strategy.payload).to eq(
        {
          text: prompt,
          voice: voice_id
        }
      )
    end
  end

  describe "#api_url" do
    it "points to fal eleven-v3 queue endpoint" do
      expect(strategy.api_url).to eq("https://queue.fal.run/fal-ai/elevenlabs/tts/eleven-v3")
    end
  end
end
