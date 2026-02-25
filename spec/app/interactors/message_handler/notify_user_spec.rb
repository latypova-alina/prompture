require "rails_helper"

describe MessageHandler::NotifyUser do
  subject { described_class.call(prompt_message:, chat_id:) }

  let(:chat_id) { 456 }
  let(:prompt_message) { create(:prompt_message) }
  let(:presenter_class) { UserMessagePresenters::MessagePresenter }

  let(:presenter) { instance_double(presenter_class) }
  let(:reply_data) { { text: "Hello", reply_markup: {} } }

  before do
    allow(presenter_class)
      .to receive(:new)
      .with(user_message: prompt_message)
      .and_return(presenter)

    allow(presenter)
      .to receive(:reply_data)
      .and_return(reply_data)

    allow(TelegramIntegration::SendMessageWithButtons)
      .to receive(:call)
  end

  it "sends a telegram message with buttons using presenter data" do
    subject

    expect(presenter_class)
      .to have_received(:new)
      .with(user_message: prompt_message)

    expect(TelegramIntegration::SendMessageWithButtons).to have_received(:call).with(chat_id:, reply_data:,
                                                                                     request: prompt_message)
  end
end
