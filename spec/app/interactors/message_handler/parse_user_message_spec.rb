require "rails_helper"

describe MessageHandler::ParseUserMessage do
  subject { described_class.call(user_message:) }

  let(:user_message) { instance_double("Telegram::Bot::Types::Message") }
  let(:message_parser) { instance_double(MessageParser) }

  let(:message_text) { "hello world" }
  let(:chat_id) { 123 }
  let(:picture_id) { "abc-123" }

  before do
    allow(MessageParser)
      .to receive(:new)
      .with(user_message)
      .and_return(message_parser)

    allow(message_parser).to receive(:message_text).and_return(message_text)
    allow(message_parser).to receive(:chat_id).and_return(chat_id)
    allow(message_parser).to receive(:picture_id).and_return(picture_id)
  end

  it "assigns parsed values to the context" do
    result = subject

    expect(result.message_text).to eq(message_text)
    expect(result.chat_id).to eq(chat_id)
    expect(result.picture_id).to eq(picture_id)

    expect(MessageParser).to have_received(:new).with(user_message)
  end
end
