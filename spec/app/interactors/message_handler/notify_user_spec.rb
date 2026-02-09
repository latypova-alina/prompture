require "rails_helper"

describe MessageHandler::NotifyUser do
  subject { described_class.call(command_request:, chat_id:) }

  let(:chat_id) { 456 }
  let(:command_request) { create(:command_prompt_to_image_request) }
  let(:presenter_class) { CommandRequestPresenters::MessagePresenter }

  let(:presenter) { instance_double(presenter_class) }
  let(:reply_data) { { text: "Hello", reply_markup: {} } }

  before do
    allow(presenter_class)
      .to receive(:new)
      .with(command_request:)
      .and_return(presenter)

    allow(presenter)
      .to receive(:reply_data)
      .and_return(reply_data)

    allow(Telegram::SendMessageWithButtons)
      .to receive(:call)
  end

  it "sends a telegram message with buttons using presenter data" do
    subject

    expect(presenter_class)
      .to have_received(:new)
      .with(command_request:)

    expect(Telegram::SendMessageWithButtons).to have_received(:call).with(chat_id:, reply_data:,
                                                                          request: command_request)
  end
end
