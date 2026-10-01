require "rails_helper"

describe Admin::UsersQuery do
  subject { described_class.call(sort: Admin::Sort.new(key, direction)).to_a }

  let(:direction) { "asc" }
  let!(:rich) do
    create(:user, name: "zed", created_at: 2.days.ago).tap do |user|
      create(:balance, user:, credits: 500)
    end
  end
  let!(:poor) do
    create(:user, name: "Amy", created_at: 1.day.ago).tap do |user|
      create(:balance, user:, credits: 5)
    end
  end
  let!(:no_balance) { create(:user, name: "bob", admin: true, created_at: 3.days.ago) }

  context "when sorting by balance descending" do
    let(:key) { "balance" }
    let(:direction) { "desc" }

    it { is_expected.to eq([rich, poor, no_balance]) }
  end

  context "when sorting by balance ascending" do
    let(:key) { "balance" }

    it "treats users without a balance as 0" do
      expect(subject).to eq([no_balance, poor, rich])
    end
  end

  context "when sorting by name" do
    let(:key) { "name" }

    it { is_expected.to eq([poor, no_balance, rich]) }
  end

  context "when sorting by admin descending" do
    let(:key) { "admin" }
    let(:direction) { "desc" }

    it { expect(subject.first).to eq(no_balance) }
  end

  context "when using the default sort" do
    let(:key) { "created" }
    let(:direction) { "desc" }

    it { is_expected.to eq([poor, rich, no_balance]) }
  end
end
