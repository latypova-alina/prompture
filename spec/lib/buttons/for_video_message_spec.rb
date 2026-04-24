require "rails_helper"

describe Buttons::ForVideoMessage do
  describe ".build" do
    subject(:result) { described_class.build(processor:) }

    let(:processor) { "kling_2_1_pro_image_to_video" }

    it "returns regenerate button row" do
      expect(result).to eq(
        [[{ callback_data: "kling_2_1_pro_image_to_video", text: "Regenerate (10 credits)" }]]
      )
    end

    context "when locale is russian" do
      subject(:result) { described_class.build(processor:, locale: :ru) }

      it "returns regenerate button row with russian pluralization" do
        expect(result).to eq(
          [[{ callback_data: "kling_2_1_pro_image_to_video", text: "Сгенерировать снова (10 кредитов)" }]]
        )
      end
    end
  end
end
