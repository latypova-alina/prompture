require "rails_helper"

describe MediaGenerator::ButtonHandler::CheckGenerationStatus do
  subject(:result) do
    described_class.call(
      button_request:,
      callback_query_id:
    )
  end

  let(:callback_query_id) { "callback-123" }
  let(:generation_request) { create(:button_video_processing_request) }
  let(:button_request) do
    "#{ButtonActions::CHECK_GENERATION_STATUS}:#{generation_request.id}:#{generation_request.class.name}"
  end
  let(:status_resolver) { instance_double(Generator::Media::FalStatusResolver, status_text: "Status text") }
  let(:telegram_bot) { double }

  before do
    allow(Generator::Media::FalStatusResolver)
      .to receive(:new)
      .with(generation_request)
      .and_return(status_resolver)
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
    allow(telegram_bot).to receive(:answer_callback_query)
  end

  it "answers callback query with status text" do
    result

    expect(telegram_bot).to have_received(:answer_callback_query).with(
      callback_query_id:,
      text: "Status text",
      show_alert: true
    )
  end

  it "is successful" do
    expect(result).to be_success
  end
end
