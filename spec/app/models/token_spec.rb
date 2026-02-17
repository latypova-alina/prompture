require "rails_helper"

describe Token, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user).optional }
  end

  describe "#expired?" do
    context "when expires_at is in the past" do
      let(:token) { build(:token, expires_at: Date.yesterday) }

      it "returns true" do
        expect(token.expired?).to be true
      end
    end

    context "when expires_at is today" do
      let(:token) { build(:token, expires_at: Date.current) }

      it "returns false" do
        expect(token.expired?).to be false
      end
    end

    context "when expires_at is in the future" do
      let(:token) { build(:token, expires_at: Date.tomorrow) }

      it "returns false" do
        expect(token.expired?).to be false
      end
    end
  end

  describe "#activated?" do
    context "when user is assigned" do
      let(:user) { create(:user) }
      let(:token) { build(:token, user:) }

      it "returns true" do
        expect(token.activated?).to be true
      end
    end

    context "when user is not assigned" do
      let(:token) { build(:token, user: nil) }

      it "returns false" do
        expect(token.activated?).to be false
      end
    end
  end
end
