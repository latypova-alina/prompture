require "rails_helper"

describe MediaGenerator::ButtonHandler::ResendMediaMessage do
  subject(:result) do
    described_class.call(parent_request:, callback_query_id: "cb-1")
  end

  let(:parent_request) { create(:button_image_processing_request, :completed) }

  before do
    allow(Telegram.bot).to receive(:send_message)
    allow(Telegram.bot).to receive(:answer_callback_query)
  end

  it "sends the media url as a standalone message and acknowledges the callback" do
    expect(result).to be_success

    expect(Telegram.bot).to have_received(:send_message).with(
      chat_id: parent_request.chat_id,
      text: parent_request.resolved_media_url
    )
    expect(Telegram.bot).to have_received(:answer_callback_query).with(callback_query_id: "cb-1")
  end
end
