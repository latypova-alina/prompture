require "rails_helper"

describe Buttons::ForExtendedPromptMessage do
  subject(:result) { described_class.build }

  it "builds processor buttons as separate rows" do
    expect(result).to eq(
      [[{ callback_data: "flux_image", text: "Flux 2 Pro (1 stone 🪨)" }],
       [{ callback_data: "nano_banana_image", text: "NanoBanana 2 (1 stone 🪨)" }]]
    )
  end

  context "when locale is russian" do
    subject(:result) { described_class.build(locale: :ru) }

    it "builds buttons with russian pluralization" do
      expect(result).to eq(
        [[{ callback_data: "flux_image", text: "Flux 2 Pro (1 камень 🪨)" }],
         [{ callback_data: "nano_banana_image", text: "NanoBanana 2 (1 камень 🪨)" }]]
      )
    end
  end
end
