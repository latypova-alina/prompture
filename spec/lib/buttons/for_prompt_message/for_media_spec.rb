require "rails_helper"

describe Buttons::ForPromptMessage::ForMedia do
  subject(:result) { described_class.build }

  it "builds processor buttons as separate rows" do
    expect(result).to eq(
      [[{ callback_data: "extend_prompt", text: "Extend prompt (1 credit)" }],
       [{ callback_data: "flux_image", text: "Flux (1 credit)" }],
       [{ callback_data: "nano_banana_image", text: "NanoBanana (1 credit)" }]]
    )
  end
end
