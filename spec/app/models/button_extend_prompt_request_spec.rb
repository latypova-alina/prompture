require "rails_helper"

describe ButtonExtendPromptRequest, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:parent_request) }
    it { is_expected.to belong_to(:command_request) }
  end

  describe "#cost" do
    subject { build(:button_extend_prompt_request) }

    it "returns 0" do
      expect(subject.cost).to eq(0)
    end
  end
end
