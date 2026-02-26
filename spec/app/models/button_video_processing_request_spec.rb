require "rails_helper"

describe ButtonVideoProcessingRequest, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:parent_request) }
    it { is_expected.to belong_to(:command_request) }
    it do
      is_expected
        .to have_one(:telegram_message)
        .dependent(:destroy)
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
    described_class::PROCESSOR_TYPES.each do |processor|
      it "returns correct humanized name for #{processor}" do
        record = build(:button_video_processing_request, processor:)

        expected_name = I18n.t("telegram.generation.humanized_process_names.video.#{processor}")
        expect(record.humanized_process_name).to eq(expected_name)
      end
    end
  end
end
