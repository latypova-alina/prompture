require "rails_helper"

describe BalanceTransaction, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:source) }
  end

  describe "validations" do
    subject { build(:balance_transaction) }

    it { is_expected.to validate_presence_of(:amount) }

    it { is_expected.to validate_presence_of(:transaction_type) }

    it do
      is_expected
        .to validate_inclusion_of(:transaction_type)
        .in_array(described_class::TRANSACTION_TYPES)
    end
  end
end
