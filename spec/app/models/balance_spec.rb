require "rails_helper"

describe Balance, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end
end
