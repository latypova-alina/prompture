require "rails_helper"
require "telegram/bot/rspec/integration/rails"

# Telegram sends my_chat_member when a user blocks or unblocks the bot in a private chat.
describe TelegramWebhooksController, telegram_bot: :rails do
  subject { user.reload.blocked_at }

  let(:chat_id) { 111 }
  let(:blocked_at) { nil }
  let!(:user) { create(:user, :with_balance, chat_id:, blocked_at:) }
  let(:update_chat_id) { chat_id }
  let(:status) { "kicked" }

  let(:update) do
    {
      update_id: 2001,
      my_chat_member: {
        chat: { id: update_chat_id, type: "private", first_name: "Alina" },
        from: { id: update_chat_id, first_name: "Alina" },
        date: 1_700_000_000,
        old_chat_member: { status: "member", user: { id: 42, is_bot: true } },
        new_chat_member: { status:, user: { id: 42, is_bot: true } }
      }
    }
  end

  # Telegram.bot is shared across examples, so clear what earlier specs sent.
  before do
    bot.reset
    dispatch(update)
  end

  context "when the user blocks the bot" do
    it { is_expected.to eq(Time.zone.at(1_700_000_000)) }
    it { expect(bot.requests).to be_empty }
    it { expect(ChatEvent.sole).to have_attributes(kind: "my_chat_member", payload: { "status" => "kicked" }) }
  end

  context "when the user unblocks the bot" do
    let(:blocked_at) { 1.day.ago }
    let(:status) { "member" }

    it { is_expected.to be_nil }
    it { expect(bot.requests).to be_empty }
  end

  context "when the chat has no user" do
    let(:update_chat_id) { 999 }

    it { is_expected.to be_nil }
    it { expect(bot.requests).to be_empty }
  end
end
