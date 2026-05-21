require "rails_helper"

describe Buttons::ForInitialPromptMessage::ForAudio do
  subject(:result) { described_class.build }

  it "builds a button row for each configured voice" do
    expect(result).to eq(
      [
        [{ callback_data: "adam", text: "Adam (2 credits)" }],
        [{ callback_data: "victoria", text: "Victoria (2 credits)" }],
        [{ callback_data: "knox_dark", text: "Knox Dark (2 credits)" }],
        [{ callback_data: "milo", text: "Milo (2 credits)" }],
        [{ callback_data: "hope", text: "Hope (2 credits)" }],
        [{ callback_data: "get_audio_samples", text: "Get samples" }]
      ]
    )
  end
end
