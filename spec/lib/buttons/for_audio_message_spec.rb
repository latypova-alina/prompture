require "rails_helper"

describe Buttons::ForAudioMessage do
  describe ".build" do
    subject(:result) { described_class.build }

    it "returns send-as-separate-message button row" do
      expect(result).to eq(
        [[{ callback_data: "send_as_separate_message", text: "Send as a separate message" }]]
      )
    end

    context "when locale is russian" do
      subject(:result) { described_class.build(locale: :ru) }

      it "returns button row translated" do
        expect(result).to eq(
          [[{ callback_data: "send_as_separate_message", text: "Отправить отдельным сообщением" }]]
        )
      end
    end
  end
end
