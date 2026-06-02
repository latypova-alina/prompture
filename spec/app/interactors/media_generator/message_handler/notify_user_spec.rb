require "rails_helper"

describe MediaGenerator::MessageHandler::NotifyUser do
  subject { described_class.call(prompt_message:) }

  let(:prompt_message) { create(:prompt_message) }
  let(:presenter_class) { MediaGenerator::UserMessage::PromptMessagePresenter }

  let(:presenter) { instance_double(presenter_class) }
  let(:reply_data) { { text: "Hello", reply_markup: {} } }

  before do
    allow(presenter_class)
      .to receive(:new)
      .with(prompt_message)
      .and_return(presenter)

    allow(presenter)
      .to receive(:reply_data)
      .and_return(reply_data)

    allow(TelegramIntegration::DeleteAdminProcessingMessage).to receive(:call)
    allow(TelegramIntegration::SendMessageWithButtons)
      .to receive(:call)
  end

  it "deletes admin processing message and sends a telegram message with buttons" do
    subject

    expect(TelegramIntegration::DeleteAdminProcessingMessage)
      .to have_received(:call)
      .with(user: prompt_message.command_request.user)

    expect(presenter_class)
      .to have_received(:new)
      .with(prompt_message)

    expect(TelegramIntegration::SendMessageWithButtons).to have_received(:call).with(reply_data:,
                                                                                     request: prompt_message)
  end
end
