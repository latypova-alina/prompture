require "rails_helper"

describe Buttons::ForExtendedPromptMessage do
  subject(:result) { described_class.build }

  it "builds processor buttons as separate rows" do
    expect(result).to eq(
      [[{ callback_data: "flux_image", text: "Flux (1 credit)" }],
       [{ callback_data: "imagen_image", text: "Imagen (0 credits)" }]]
    )
  end

  context "when locale is russian" do
    subject(:result) { described_class.build(locale: :ru) }

    it "builds buttons with russian pluralization" do
      expect(result).to eq(
        [[{ callback_data: "flux_image", text: "Flux (1 кредит)" }],
         [{ callback_data: "imagen_image", text: "Imagen (0 кредитов)" }]]
      )
    end
  end
end
