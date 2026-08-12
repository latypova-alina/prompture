require "rails_helper"

describe Buttons::ForImageMessage::ForPromptToImage do
  describe ".build" do
    subject(:result) { described_class.build(processor:) }

    let(:processor) { "flux_image" }

    it "returns regenerate and send-as-separate-message button rows" do
      expect(result).to eq(
        [
          [{ callback_data: "flux_image", text: "Regenerate (1 stone 🪨)" }],
          [{ callback_data: "send_as_separate_message", text: "Send as a separate message" }]
        ]
      )
    end

    context "when locale is russian" do
      subject(:result) { described_class.build(processor:, locale: :ru) }

      it "returns button rows with russian pluralization" do
        expect(result).to eq(
          [
            [{ callback_data: "flux_image", text: "Сгенерировать снова (1 камень 🪨)" }],
            [{ callback_data: "send_as_separate_message", text: "Отправить отдельным сообщением" }]
          ]
        )
      end
    end
  end
end
