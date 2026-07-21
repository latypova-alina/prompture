require "rails_helper"

describe MediaGenerator::ButtonHandler::ClearInlineKeyboard do
  subject(:result) { described_class.call(chat_id:, tg_message_id:) }

  let(:chat_id) { 456 }
  let(:tg_message_id) { 99 }

  before do
    allow(Telegram.bot).to receive(:edit_message_reply_markup)
  end

  it "clears the inline keyboard on the source message" do
    expect(result).to be_success

    expect(Telegram.bot).to have_received(:edit_message_reply_markup).with(
      chat_id:,
      message_id: tg_message_id,
      reply_markup: { inline_keyboard: [] }
    )
  end

  context "when chat_id is blank" do
    let(:chat_id) { nil }

    it "does not edit the message" do
      expect(result).to be_success
      expect(Telegram.bot).not_to have_received(:edit_message_reply_markup)
    end
  end

  context "when tg_message_id is blank" do
    let(:tg_message_id) { nil }

    it "does not edit the message" do
      expect(result).to be_success
      expect(Telegram.bot).not_to have_received(:edit_message_reply_markup)
    end
  end

  context "when Telegram raises an error" do
    before do
      allow(Telegram.bot)
        .to receive(:edit_message_reply_markup)
        .and_raise(Telegram::Bot::Error, "message is not modified")
    end

    it "swallows the error" do
      expect(result).to be_success
    end
  end
end
