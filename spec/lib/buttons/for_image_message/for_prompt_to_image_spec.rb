require "rails_helper"

describe Buttons::ForImageMessage::ForPromptToImage do
  describe ".build" do
    subject(:result) { described_class.build(processor:) }

    let(:processor) { "flux_image" }

    it "returns regenerate button row" do
      expect(result).to eq(
        [[{ callback_data: "flux_image", text: "Regenerate (1 credit)" }]]
      )
    end

    context "when locale is russian" do
      subject(:result) { described_class.build(processor:, locale: :ru) }

      it "returns regenerate button row with russian pluralization" do
        expect(result).to eq(
          [[{ callback_data: "flux_image", text: "Сгенерировать снова (1 кредит)" }]]
        )
      end
    end
  end
end
