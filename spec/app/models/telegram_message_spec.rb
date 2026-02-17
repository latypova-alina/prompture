require "rails_helper"

describe TelegramMessage, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:request) }
  end
end
