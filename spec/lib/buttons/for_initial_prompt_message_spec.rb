require "rails_helper"

describe Buttons::ForInitialPromptMessage do
  subject(:result) { described_class.build }

  it "builds processor buttons as separate rows" do
    expect(result).to eq(
      [[{ callback_data: "extend_prompt", text: "Extend prompt" }],
       [{ callback_data: "mystic_image", text: "Mystic (2 credits)" }],
       [{ callback_data: "gemini_image", text: "Gemini (1 credit)" }],
       [{ callback_data: "imagen_image", text: "Imagen (0 credits)" }]]
    )
  end
end
