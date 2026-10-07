require "rails_helper"

describe UserBlocks::FailedSendMarker do
  subject { user.reload.blocked_at }

  let(:chat_id) { 111 }
  let(:blocked_at) { nil }
  let!(:user) { create(:user, chat_id:, blocked_at:) }
  let(:body) { { chat_id: } }
  let(:error) { Telegram::Bot::Forbidden.new("Forbidden: bot was blocked by the user") }

  before { described_class.call(body:, error:) }

  context "when the user blocked the bot" do
    it { is_expected.to be_within(1.minute).of(Time.current) }
  end

  context "when the user is already marked as blocked" do
    let(:blocked_at) { Time.zone.parse("2026-01-01 10:00") }

    it { is_expected.to eq(blocked_at) }
  end

  context "when the chat id is a string" do
    let(:body) { { "chat_id" => chat_id.to_s } }

    it { is_expected.to be_present }
  end

  context "when the account is deactivated" do
    let(:error) { Telegram::Bot::Forbidden.new("Forbidden: user is deactivated") }

    it { is_expected.to be_nil }
  end

  context "when the error isn't Forbidden" do
    let(:error) { Telegram::Bot::Error.new("Bad Request: chat not found") }

    it { is_expected.to be_nil }
  end
end
