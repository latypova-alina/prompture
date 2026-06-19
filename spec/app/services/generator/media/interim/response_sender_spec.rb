require "rails_helper"

describe Generator::Media::Interim::ResponseSender do
  subject(:tg_message_id) { described_class.new(request:).tg_message_id }

  let(:telegram_bot) { double }
  let(:inline_keyboard) { [[{ text: "Check", callback_data: "check" }]] }
  let(:presenter_double) do
    instance_double(
      MediaGenerator::GenerationStatus::BasePresenter,
      inline_keyboard:,
      message_payload_text:
    )
  end

  before do
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
    allow(telegram_bot).to receive(:send_message).and_return("result" => { "message_id" => 42_001 })
    allow(MediaGenerator::GenerationStatus::PresenterSelector)
      .to receive(:new)
      .with(request:)
      .and_return(instance_double(MediaGenerator::GenerationStatus::PresenterSelector, presenter: presenter_double))
  end

  context "when request is a video processing request" do
    let(:request) { create(:button_video_processing_request) }
    let(:message_payload_text) { I18n.t("errors.video_generating_interim") }

    it "sends interim message with video copy" do
      expect(tg_message_id).to eq(42_001)

      expect(telegram_bot).to have_received(:send_message).with(
        chat_id: request.chat_id,
        text: message_payload_text,
        reply_markup: { inline_keyboard: }
      )
    end
  end

  context "when request is an image processing request" do
    let(:request) { create(:button_image_processing_request) }
    let(:message_payload_text) { I18n.t("errors.media_generating_interim") }

    it "sends interim message without cancellation copy" do
      expect(tg_message_id).to eq(42_001)

      expect(telegram_bot).to have_received(:send_message).with(
        chat_id: request.chat_id,
        text: message_payload_text,
        reply_markup: { inline_keyboard: }
      )
    end
  end
end
