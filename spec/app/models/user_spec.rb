require "rails_helper"

describe User, type: :model do
  describe "associations" do
    it { is_expected.to have_one(:balance).dependent(:destroy) }
    it { is_expected.to have_many(:tokens).dependent(:destroy) }
  end
end
