require "rails_helper"

describe MediaGenerator::MessageHandler::ImageMessageHandler::NotifyUser do
  subject(:call_interactor) { described_class.call(image_message:) }

  let(:image_message) { create(:image_message) }
  let(:presenter_class) { MediaGenerator::UserMessagePresenters::ImageMessagePresenter }
  let(:presenter) { instance_double(presenter_class) }
  let(:reply_data) { { text: "Hello", reply_markup: {} } }

  before do
    allow(presenter_class)
      .to receive(:new)
      .with(message: image_message.image_url)
      .and_return(presenter)

    allow(presenter)
      .to receive(:reply_data)
      .and_return(reply_data)

    allow(TelegramIntegration::SendMessageWithButtons)
      .to receive(:call)
  end

  it "sends a telegram message with buttons using presenter data" do
    call_interactor

    expect(presenter_class)
      .to have_received(:new)
      .with(message: image_message.image_url)

    expect(TelegramIntegration::SendMessageWithButtons).to have_received(:call).with(
      reply_data:,
      request: image_message
    )
  end
end
