require "rails_helper"

describe Generator::Media::Interim::Notifier::Fail do
  subject(:call_notifier) do
    described_class.call(generation_request:, callback_query_id:)
  end

  let(:callback_query_id) { "callback-123" }
  let(:generation_request) do
    create(:button_video_processing_request, interim_tg_message_id: 77_001)
  end
  let(:telegram_bot) { double }

  before do
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
    allow(telegram_bot).to receive_messages(answer_callback_query: nil, send_message: nil)
  end

  it "notifies user about failed cancellation and answers callback query" do
    call_notifier

    expect(telegram_bot).to have_received(:send_message).with(
      chat_id: generation_request.chat_id,
      text: I18n.t("errors.generation_cancel_failed")
    )
    expect(telegram_bot).to have_received(:answer_callback_query).with(callback_query_id:)
  end
end
