require "rails_helper"

describe Buttons::ForImageMessage::ForPromptToImage do
  describe ".build" do
    subject(:result) { described_class.build(processor:) }

    let(:processor) { "mystic_image" }

    it "returns regenerate button row" do
      expect(result).to eq(
        [[{ callback_data: "mystic_image", text: "Regenerate (2 credits)" }]]
      )
    end

    context "when locale is russian" do
      subject(:result) { described_class.build(processor:, locale: :ru) }

      it "returns regenerate button row with russian pluralization" do
        expect(result).to eq(
          [[{ callback_data: "mystic_image", text: "Сгенерировать снова (2 кредита)" }]]
        )
      end
    end
  end
end
