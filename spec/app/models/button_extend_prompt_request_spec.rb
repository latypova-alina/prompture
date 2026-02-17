require "rails_helper"

describe ButtonExtendPromptRequest, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:parent_request) }
    it { is_expected.to belong_to(:command_request) }
    it do
      is_expected
        .to have_one(:telegram_message)
        .dependent(:destroy)
    end
  end

  describe "#cost" do
    subject { build(:button_extend_prompt_request) }

    it "returns 0" do
      expect(subject.cost).to eq(0)
    end
  end

  describe "#humanized_process_name" do
    subject { build(:button_extend_prompt_request) }

    it "returns the correct I18n translation" do
      expected_name = I18n.t("telegram.generation.humanized_process_names.extend_prompt")
      expect(subject.humanized_process_name).to eq(expected_name)
    end
  end
end
