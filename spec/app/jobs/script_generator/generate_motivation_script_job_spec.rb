require "rails_helper"

describe ScriptGenerator::GenerateMotivationScriptJob do
  describe "#perform" do
    before do
      allow(Telegram).to receive_message_chain(:bot, :send_message)
    end

    it "delegates to ScriptGenerator::ProcessMotivationScript service" do
      expect(ScriptGenerator::ProcessMotivationScript).to receive(:call).with(chat_id: 456, language: "pl")

      described_class.new.perform(456, "pl")
    end

    context "when script generator request fails" do
      before do
        allow(ScriptGenerator::ProcessMotivationScript).to receive(:call)
          .and_raise(ScriptGeneratorRequestError, "invalid response")
      end

      it "sends error message to user" do
        described_class.new.perform(456)

        expect(Telegram.bot).to have_received(:send_message).with(chat_id: 456, text: "invalid response")
      end
    end
  end
end
