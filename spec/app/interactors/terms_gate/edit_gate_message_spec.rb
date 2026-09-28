require "rails_helper"

describe TermsGate::EditGateMessage do
  subject(:call) { described_class.call(chat_id:, tg_message_id:, user:) }

  let(:chat_id) { 456 }
  let(:tg_message_id) { 789 }
  let(:user) { create(:user, locale: "en") }
  let(:telegram_bot) { double }

  before do
    allow(Telegram).to receive(:bot).and_return(telegram_bot)
    allow(telegram_bot).to receive(:edit_message_text)
  end

  it "edits the message asking the user to send the command again, and removes the button" do
    call

    expect(telegram_bot).to have_received(:edit_message_text).with(
      chat_id:,
      message_id: tg_message_id,
      text: I18n.t("telegram_webhooks.message.terms_gate.accepted", locale: "en"),
      reply_markup: { inline_keyboard: [] }
    )
  end
end
