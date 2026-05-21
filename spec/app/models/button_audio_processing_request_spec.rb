require "rails_helper"

RSpec.describe ButtonAudioProcessingRequest do
  subject(:request) { build(:button_audio_processing_request, voice:, processor:) }

  let(:voice) { "adam" }
  let(:processor) { "elevenlabs_turbo_v2_5_audio" }

  describe "validations" do
    it "is valid with a known voice" do
      expect(request).to be_valid
    end

    it "is invalid with an unknown voice" do
      request.voice = "unknown"

      expect(request).not_to be_valid
      expect(request.errors[:voice]).to be_present
    end
  end

  describe "#voice_id" do
    it "returns the ElevenLabs id from the voice catalog" do
      request.voice = "hope"

      expect(request.voice_id).to eq("tnSpp4vdxKPjI9w0GnoV")
    end
  end

  describe "#cost" do
    it "uses processor pricing" do
      expect(request.cost).to eq(COSTS[:generate_audio][:elevenlabs_turbo_v2_5_audio])
    end
  end
end
