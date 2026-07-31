require "rails_helper"

describe MediaGenerator::ButtonHandler::SendAsSeparateMessage do
  subject(:result) do
    described_class.call(
      chat_id:,
      tg_message_id:,
      callback_query_id: "cb-1"
    )
  end

  let(:chat_id) { generation_request.chat_id }
  let(:tg_message_id) { existing_tg_message_id }
  let(:existing_tg_message_id) { 99 }
  let(:generation_request) { create(:button_image_processing_request, :completed) }

  before do
    create(:bot_telegram_message, request: generation_request, chat_id:, tg_message_id: existing_tg_message_id)
    allow(Telegram.bot).to receive(:send_message)
    allow(Telegram.bot).to receive(:answer_callback_query)
  end

  it "sends the media url as a standalone message and acknowledges the callback" do
    expect(result).to be_success

    expect(Telegram.bot).to have_received(:send_message).with(
      chat_id:,
      text: generation_request.resolved_media_url
    )
    expect(Telegram.bot).to have_received(:answer_callback_query).with(callback_query_id: "cb-1")
  end

  context "when no telegram message matches" do
    let(:tg_message_id) { 12_345 }

    it "fails with ParentNotFoundError" do
      expect(result).to be_failure
      expect(result.error).to eq(ParentNotFoundError)
      expect(Telegram.bot).not_to have_received(:send_message)
    end
  end
end
