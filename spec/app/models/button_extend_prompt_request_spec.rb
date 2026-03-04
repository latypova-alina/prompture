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

  describe "delegations" do
    let(:user) { create(:user, locale: "es") }
    let(:command_request) { create(:command_prompt_to_image_request, chat_id: 123, user:) }

    subject(:button_request) do
      create(
        :button_extend_prompt_request,
        command_request:,
        parent_request: command_request
      )
    end

    it "delegates user to command_request" do
      expect(button_request.user).to eq(user)
    end

    it "delegates chat_id to command_request" do
      expect(button_request.chat_id).to eq(123)
    end

    it "delegates locale to user" do
      expect(button_request.locale).to eq("es")
    end
  end

  describe "#cost" do
    subject { build(:button_extend_prompt_request) }

    it "returns 0" do
      expect(subject.cost).to eq(1)
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
