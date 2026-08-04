require "rails_helper"

describe Buttons::ForVideoMessage do
  describe ".build" do
    subject(:result) { described_class.build(processor:) }

    let(:processor) { "kling_2_1_pro_image_to_video" }

    it "returns regenerate and send-as-separate-message button rows" do
      expect(result).to eq(
        [
          [{ callback_data: "kling_2_1_pro_image_to_video", text: "Regenerate (10 inks 🖋️)" }],
          [{ callback_data: "send_as_separate_message", text: "Send as a separate message" }]
        ]
      )
    end

    context "when locale is russian" do
      subject(:result) { described_class.build(processor:, locale: :ru) }

      it "returns button rows with russian pluralization" do
        expect(result).to eq(
          [
            [{ callback_data: "kling_2_1_pro_image_to_video", text: "Сгенерировать снова (10 инков 🖋️)" }],
            [{ callback_data: "send_as_separate_message", text: "Отправить отдельным сообщением" }]
          ]
        )
      end
    end
  end
end
