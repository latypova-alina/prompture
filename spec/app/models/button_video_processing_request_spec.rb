require "rails_helper"

describe ButtonVideoProcessingRequest, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:parent_request) }
    it { is_expected.to belong_to(:command_request) }
    it do
      is_expected
        .to have_one(:bot_telegram_message)
        .dependent(:destroy)
    end
  end

  describe "delegations" do
    let(:user) { create(:user, locale: "es") }
    let(:command_request) { create(:command_prompt_to_video_request, chat_id: 123, user:) }

    subject(:button_request) do
      create(
        :button_video_processing_request,
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
    subject { build(:button_video_processing_request) }

    it { is_expected.to validate_presence_of(:processor) }

    it do
      is_expected
        .to validate_inclusion_of(:processor)
        .in_array(described_class::PROCESSOR_TYPES)
    end
  end

  describe "#cost" do
    described_class::PROCESSOR_TYPES.each do |processor|
      it "returns correct cost for #{processor}" do
        record = build(:button_video_processing_request, processor:)

        expect(record.cost)
          .to eq(COSTS[:generate_video][processor.to_sym])
      end
    end
  end

  describe "#humanized_process_name" do
    let(:user) { create(:user, locale: "es") }
    let(:command_request) { create(:command_prompt_to_video_request, user:) }

    described_class::PROCESSOR_TYPES.each do |processor|
      it "returns correct humanized name for #{processor}" do
        record = build(:button_video_processing_request, processor:, command_request:)

        expected_name = I18n.t("telegram.generation.humanized_process_names.video.#{processor}", locale: "es")
        expect(record.humanized_process_name).to eq(expected_name)
      end
    end
  end
end
