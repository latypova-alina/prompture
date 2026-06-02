require "rails_helper"

describe MediaGenerator::MessageHandler::EditImageMessageHandler::NotifyProcessingStarted do
  subject(:call_interactor) { described_class.call(context) }

  let(:user) { create(:user) }
  let(:command_request) { create(:command_edit_image_request, user:) }
  let(:button_request_record) do
    create(
      :button_image_processing_request,
      command_request:,
      processor: "nano_banana_edit_image"
    )
  end
  let(:context) do
    Interactor::Context.build(
      command_request:,
      button_request_record:
    )
  end

  let(:bot) { instance_double(Telegram::Bot::Client) }
  let(:telegram_response) do
    {
      "ok" => true,
      "result" => {
        "message_id" => 555
      }
    }
  end

  before do
    allow(Telegram).to receive(:bot).and_return(bot)
    allow(bot).to receive(:send_message).and_return(telegram_response)
  end

  describe ".call" do
    it "sends processing message and records it on the button request" do
      expect { call_interactor }
        .to change(BotTelegramMessage, :count).by(1)

      expect(bot)
        .to have_received(:send_message)
        .with(
          chat_id: command_request.chat_id,
          text: I18n.t(
            "telegram.generation.processing",
            process_name: button_request_record.humanized_process_name
          )
        )

      record = BotTelegramMessage.last

      expect(record.request).to eq(button_request_record)
      expect(record.tg_message_id).to eq(555)
    end
  end
end
