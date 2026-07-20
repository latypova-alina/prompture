require "rails_helper"

describe ScriptGenerator::Process::ForBloomy::ShortComplexScriptJob do
  describe "#perform" do
    before do
      allow(Telegram).to receive_message_chain(:bot, :send_message)
    end

    it "delegates to ScriptGenerator::ForBloomy::ShortComplexScript::Processor service" do
      expect(ScriptGenerator::ForBloomy::ShortComplexScript::Processor).to receive(:call).with(chat_id: 456)

      described_class.new.perform(456)
    end

    context "when script generator request fails" do
      before do
        allow(ScriptGenerator::ForBloomy::ShortComplexScript::Processor).to receive(:call)
          .and_raise(ScriptGeneratorRequestError, "scenes are blank")
      end

      it "sends error message to user" do
        described_class.new.perform(456)

        expect(Telegram.bot).to have_received(:send_message).with(
          chat_id: 456,
          text: "scenes are blank"
        )
      end
    end
  end
end
