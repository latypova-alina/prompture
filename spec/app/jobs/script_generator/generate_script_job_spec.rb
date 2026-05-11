require "rails_helper"

describe ScriptGenerator::GenerateScriptJob do
  describe "#perform" do
    before do
      allow(Telegram).to receive_message_chain(:bot, :send_message)
    end

    it "delegates to ScriptGenerator::ProcessGeneratedScripts service" do
      expect(ScriptGenerator::ProcessGeneratedScripts).to receive(:call).with(chat_id: 456, template_name: nil)

      described_class.new.perform(456)
    end

    context "when script generator request fails" do
      before do
        allow(ScriptGenerator::ProcessGeneratedScripts).to receive(:call)
          .and_raise(ScriptGeneratorRequestError, "template not found")
      end

      it "sends error message to user" do
        described_class.new.perform(456, "missing_template")

        expect(Telegram.bot).to have_received(:send_message).with(chat_id: 456, text: "template not found")
      end
    end

    context "when unexpected error occurs" do
      before do
        allow(ScriptGenerator::ProcessGeneratedScripts).to receive(:call).and_raise(StandardError, "boom")
      end

      it "sends default error message to user" do
        described_class.new.perform(456)

        expect(Telegram.bot).to have_received(:send_message).with(
          chat_id: 456,
          text: I18n.t("errors.script_generator_request_failed")
        )
      end
    end
  end
end
