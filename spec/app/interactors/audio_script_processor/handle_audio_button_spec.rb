require "rails_helper"

describe AudioScriptProcessor::HandleAudioButton do
  subject(:result) { described_class.call(chat_id:, prompt_message:, voice:) }

  let(:voice) { nil }

  let(:chat_id) { 456 }
  let(:prompt_message) { create(:prompt_message, command_request:) }
  let(:command_request) { create(:command_prompt_to_audio_request, chat_id:) }

  describe "#call" do
    context "when bot message exists" do
      let!(:bot_message) { create(:bot_telegram_message, request: prompt_message, chat_id:, tg_message_id: 123_456) }

      before do
        allow(MediaGenerator::ButtonHandler::HandleButton)
          .to receive(:call)
          .and_return(instance_double(Interactor::Context, failure?: false))
      end

      it "calls media button handler with default voice and tg_message_id" do
        result

        expect(MediaGenerator::ButtonHandler::HandleButton).to have_received(:call).with(
          button_request: "adam",
          chat_id:,
          tg_message_id: bot_message.tg_message_id,
          callback_query_id: nil
        )
      end

      context "when voice is provided" do
        let(:voice) { "knox_dark" }

        it "calls media button handler with the given voice" do
          result

          expect(MediaGenerator::ButtonHandler::HandleButton).to have_received(:call).with(
            button_request: "knox_dark",
            chat_id:,
            tg_message_id: bot_message.tg_message_id,
            callback_query_id: nil
          )
        end
      end
    end

    context "when bot message is missing" do
      it "fails with ParentNotFoundError" do
        expect(result).to be_failure
        expect(result.error).to eq(ParentNotFoundError)
      end
    end
  end
end
