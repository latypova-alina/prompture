require "rails_helper"

describe TelegramIntegration::DeleteMessage do
  subject(:call_service) { described_class.call(chat_id:, message_id:) }

  let(:chat_id) { 123 }
  let(:telegram_bot) { double }

  before do
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
    allow(telegram_bot).to receive(:delete_message)
  end

  context "when message_id is present" do
    let(:message_id) { 456 }

    it "deletes telegram message" do
      call_service

      expect(telegram_bot).to have_received(:delete_message).with(chat_id:, message_id:)
    end
  end

  context "when message_id is blank" do
    let(:message_id) { nil }

    it "does not call telegram" do
      call_service

      expect(telegram_bot).not_to have_received(:delete_message)
    end
  end
end
