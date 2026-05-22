require "rails_helper"

describe ScriptGenerator::ForMotivation::GenerateMotivationWorkflowJob do
  describe "#perform" do
    it "delegates to ProcessMotivationWorkflow service" do
      expect(ScriptGenerator::ForMotivation::ProcessMotivationWorkflow).to receive(:call).with(
        chat_id: 456,
        language: "en"
      )

      described_class.new.perform(456, "en")
    end

    context "when processing fails" do
      before do
        allow(ScriptGenerator::ForMotivation::ProcessMotivationWorkflow).to receive(:call)
          .and_raise(ScriptGeneratorRequestError, "invalid response")
        allow(Telegram.bot).to receive(:send_message)
      end

      it "notifies user about script generator error" do
        described_class.new.perform(456, "en")

        expect(Telegram.bot).to have_received(:send_message).with(
          chat_id: 456,
          text: "invalid response"
        )
      end
    end
  end
end
