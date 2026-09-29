require "rails_helper"

describe Admin::DateRangeFilter do
  subject(:apply) { described_class.new(date_from:, date_to:).apply(User.all) }

  let!(:old_user) { create(:user, :with_balance, created_at: 10.days.ago) }
  let!(:recent_user) { create(:user, :with_balance, created_at: 1.day.ago) }

  context "when no dates are given" do
    let(:date_from) { nil }
    let(:date_to) { nil }

    it { is_expected.to contain_exactly(old_user, recent_user) }
  end

  context "when date_from excludes the older record" do
    let(:date_from) { 5.days.ago.to_date.to_s }
    let(:date_to) { nil }

    it { is_expected.to contain_exactly(recent_user) }
  end

  context "when date_to excludes the recent record" do
    let(:date_from) { nil }
    let(:date_to) { 5.days.ago.to_date.to_s }

    it { is_expected.to contain_exactly(old_user) }
  end

  context "when given an invalid date string" do
    let(:date_from) { "not-a-date" }
    let(:date_to) { nil }

    it { is_expected.to contain_exactly(old_user, recent_user) }
  end
end
