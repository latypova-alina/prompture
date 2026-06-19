require "rails_helper"

describe Generator::Media::Interim::Notifier::Outdated do
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
    allow(telegram_bot).to receive(:answer_callback_query)
  end

  it "shows already processing alert" do
    call_notifier

    expect(telegram_bot).to have_received(:answer_callback_query).with(
      callback_query_id:,
      text: I18n.t(
        "errors.generation_already_processing",
        processor_name: generation_request.humanized_process_name
      ),
      show_alert: true
    )
  end
end
