require "rails_helper"

describe WelcomeBonus, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "cap" do
    it "rejects the 101st welcome bonus" do
      100.times { create(:welcome_bonus) }

      expect { create(:welcome_bonus) }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end
end
