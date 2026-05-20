require "rails_helper"

describe Buttons::ForInitialPromptMessage::ForAudio do
  subject(:result) { described_class.build }

  it "builds audio processor buttons" do
    expect(result).to eq(
      [[{ callback_data: "elevenlabs_turbo_v2_5_audio", text: "ElevenLabs Turbo (2 credits)" }]]
    )
  end
end
