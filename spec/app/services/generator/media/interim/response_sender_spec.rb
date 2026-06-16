require "rails_helper"

describe Generator::Media::Interim::ResponseSender do
  subject(:tg_message_id) { described_class.new(request:).tg_message_id }

  let(:request) { create(:button_video_processing_request) }
  let(:telegram_bot) { double }
  let(:inline_keyboard) { [[{ text: "Check", callback_data: "check" }]] }

  before do
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
    allow(telegram_bot).to receive(:send_message).and_return("result" => { "message_id" => 42_001 })
    allow(MediaGenerator::GenerationStatusPresenter)
      .to receive(:new)
      .with(request)
      .and_return(instance_double(MediaGenerator::GenerationStatusPresenter, inline_keyboard:))
  end

  it "sends interim message with status keyboard" do
    expect(tg_message_id).to eq(42_001)

    expect(telegram_bot).to have_received(:send_message).with(
      chat_id: request.chat_id,
      text: I18n.t("errors.media_generating_interim"),
      reply_markup: { inline_keyboard: }
    )
  end
end
