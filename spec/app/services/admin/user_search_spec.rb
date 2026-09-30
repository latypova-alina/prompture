require "rails_helper"

describe Admin::UserSearch do
  subject(:call) { described_class.call(query) }

  let!(:rihanna) { create(:user, :with_balance, name: "Rihanna", chat_id: 555_001) }
  let!(:beyonce) { create(:user, :with_balance, name: "Beyonce", chat_id: 555_002) }

  context "when the query is blank" do
    let(:query) { "" }

    it { is_expected.to eq(User.none) }
  end

  context "when the query matches a name case-insensitively" do
    let(:query) { "rihan" }

    it { is_expected.to contain_exactly(rihanna) }
  end

  context "when the query is an exact chat_id" do
    let(:query) { rihanna.chat_id.to_s }

    it { is_expected.to contain_exactly(rihanna) }
  end

  context "when the query is an exact id" do
    let(:query) { rihanna.id.to_s }

    it { is_expected.to contain_exactly(rihanna) }
  end

  context "when the query matches nothing" do
    let(:query) { "nobody-has-this-name" }

    it { is_expected.to be_empty }
  end

  context "when the query is non-numeric and does not match any name" do
    let(:query) { "not-a-number" }

    it "does not error trying to compare it against id/chat_id" do
      expect { call.to_a }.not_to raise_error
    end
  end
end
