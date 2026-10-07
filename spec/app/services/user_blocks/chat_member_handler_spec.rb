require "rails_helper"

describe UserBlocks::ChatMemberHandler do
  subject { user.reload.blocked_at }

  let(:chat_id) { 111 }
  let(:blocked_at) { nil }
  let!(:user) { create(:user, chat_id:, blocked_at:) }
  let(:chat_type) { "private" }
  let(:status) { "kicked" }
  let(:date) { 1_700_000_000 }

  let(:chat_member) do
    {
      "chat" => { "id" => chat_id, "type" => chat_type },
      "date" => date,
      "old_chat_member" => { "status" => "member" },
      "new_chat_member" => { "status" => status }
    }
  end

  before { described_class.call(chat_member) }

  context "when the user blocks the bot" do
    it { is_expected.to eq(Time.zone.at(date)) }
  end

  context "when the user unblocks the bot" do
    let(:blocked_at) { 1.day.ago }
    let(:status) { "member" }

    it { is_expected.to be_nil }
  end

  context "when the update is from a group" do
    let(:chat_type) { "group" }

    it { is_expected.to be_nil }
  end

  context "when the status is neither kicked nor member" do
    let(:status) { "left" }

    it { is_expected.to be_nil }
  end

  context "when the chat has no user" do
    subject { -> { described_class.call(chat_member.deep_merge("chat" => { "id" => 999 })) } }

    it { is_expected.not_to raise_error }
  end
end
