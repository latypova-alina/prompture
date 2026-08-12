require "rails_helper"

describe Buttons::ForPromptMessage::ForMedia do
  subject(:result) { described_class.build }

  it "builds processor buttons as separate rows" do
    expect(result).to eq(
      [[{ callback_data: "extend_prompt", text: "Extend prompt (1 stone 🪨)" }],
       [{ callback_data: "flux_image", text: "Flux 2 Pro (1 stone 🪨)" }],
       [{ callback_data: "nano_banana_image", text: "NanoBanana 2 (1 stone 🪨)" }]]
    )
  end
end
