require "rails_helper"

describe Buttons::ForPromptMessage::ForAudio do
  subject(:result) { described_class.build }

  it "builds a button row for each configured voice" do
    expect(result).to eq(
      [
        [{ callback_data: "adam", text: "Adam (1 stone 🪨)" }],
        [{ callback_data: "victoria", text: "Victoria (1 stone 🪨)" }],
        [{ callback_data: "knox", text: "Knox (1 stone 🪨)" }],
        [{ callback_data: "milo", text: "Milo (1 stone 🪨)" }],
        [{ callback_data: "hope", text: "Hope (1 stone 🪨)" }],
        [{ callback_data: "lulu_lollipop", text: "Lulu Lollipop (1 stone 🪨)" }],
        [{ callback_data: "get_audio_samples", text: "Get samples" }]
      ]
    )
  end
end
