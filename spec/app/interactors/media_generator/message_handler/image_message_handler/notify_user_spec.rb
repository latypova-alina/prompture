require "rails_helper"

describe MediaGenerator::MessageHandler::ImageMessageHandler::NotifyUser do
  subject(:call_interactor) { described_class.call(image_record:) }

  let(:image_record) { create(:image_url_message) }
  let(:selector_class) { MediaGenerator::UserMessage::ImageMessage::PresenterSelector }
  let(:presenter) { instance_double(presenter_class) }
  let(:presenter_class) { MediaGenerator::UserMessage::ImageMessage::ImageUrlMessagePresenter }
  let(:reply_data) { { text: "Hello", reply_markup: {} } }
  let(:selector) { instance_double(selector_class) }

  before do
    allow(selector_class)
      .to receive(:new)
      .with(request: image_record)
      .and_return(selector)

    allow(selector)
      .to receive(:presenter)
      .and_return(presenter)

    allow(presenter)
      .to receive(:reply_data)
      .and_return(reply_data)

    allow(TelegramIntegration::SendMessageWithButtons)
      .to receive(:call)
  end

  it "sends a telegram message with buttons using presenter data" do
    call_interactor

    expect(selector_class)
      .to have_received(:new)
      .with(request: image_record)

    expect(TelegramIntegration::SendMessageWithButtons).to have_received(:call).with(
      reply_data:,
      request: image_record
    )
  end

  context "when image_record is picture_message" do
    let(:image_record) { create(:picture_message) }
    let(:presenter_class) { MediaGenerator::UserMessage::ImageMessage::PictureMessagePresenter }

    before do
      allow(selector_class)
        .to receive(:new)
        .with(request: image_record)
        .and_return(selector)

      allow(selector)
        .to receive(:presenter)
        .and_return(presenter)
    end

    it "uses picture_message as request" do
      call_interactor

      expect(TelegramIntegration::SendMessageWithButtons).to have_received(:call).with(
        reply_data:,
        request: image_record
      )
    end
  end
end
