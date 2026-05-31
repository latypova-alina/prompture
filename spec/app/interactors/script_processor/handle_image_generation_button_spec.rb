require "rails_helper"

describe ScriptProcessor::HandleImageGenerationButton do
  subject(:result) { described_class.call(chat_id:, prompt_message:) }

  let(:chat_id) { 456 }
  let(:prompt_message) { create(:prompt_message, command_request:) }
  let(:command_request) { create(:command_prompt_to_video_request, chat_id:) }

  describe "#call" do
    context "when bot message exists" do
      let!(:bot_message) { create(:bot_telegram_message, request: prompt_message, chat_id:, tg_message_id: 123_456) }

      before do
        allow(MediaGenerator::ButtonHandler::HandleButton)
          .to receive(:call)
          .and_return(instance_double(Interactor::Context, failure?: false))
      end

      it "calls media button handler with flux button and tg_message_id" do
        result

        expect(MediaGenerator::ButtonHandler::HandleButton).to have_received(:call).with(
          button_request: "flux_image",
          chat_id:,
          tg_message_id: bot_message.tg_message_id,
          callback_query_id: nil
        )
      end
    end

    context "when command request category is cartoon_character" do
      let(:command_request) do
        create(:command_prompt_to_video_request, chat_id:, category: ContentCategory::CARTOON_CHARACTER)
      end
      let!(:bot_message) { create(:bot_telegram_message, request: prompt_message, chat_id:, tg_message_id: 123_456) }

      before do
        allow(MediaGenerator::ButtonHandler::HandleButton)
          .to receive(:call)
          .and_return(instance_double(Interactor::Context, failure?: false))
      end

      it "calls media button handler with nano banana button" do
        result

        expect(MediaGenerator::ButtonHandler::HandleButton).to have_received(:call).with(
          button_request: "nano_banana_image",
          chat_id:,
          tg_message_id: bot_message.tg_message_id,
          callback_query_id: nil
        )
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
