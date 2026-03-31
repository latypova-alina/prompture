require "rails_helper"

describe ButtonImageProcessingRequest, type: :model do
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
        :button_image_processing_request,
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

  describe "validations" do
    subject { build(:button_image_processing_request) }

    it { is_expected.to validate_presence_of(:processor) }

    it "validates inclusion of processor" do
      expect(subject).to validate_inclusion_of(:processor)
        .in_array(described_class::PROCESSOR_TYPES)
    end
  end

  describe "#cost" do
    let(:processor) { "mystic_image" }

    subject do
      build(:button_image_processing_request, processor:)
    end

    it "returns correct cost from COSTS config" do
      expect(subject.cost).to eq(
        COSTS[:generate_image][processor.to_sym]
      )
    end
  end

  describe "#humanized_process_name" do
    let(:processor) { "mystic_image" }
    let(:user) { create(:user, locale: "es") }
    let(:command_request) { create(:command_prompt_to_image_request, user:) }

    subject do
      build(:button_image_processing_request, processor:, command_request:)
    end

    it "returns humanized processor name" do
      expected_name = I18n.t("telegram.generation.humanized_process_names.image.#{processor}", locale: "es")
      expect(subject.humanized_process_name).to eq(expected_name)
    end
  end
end
