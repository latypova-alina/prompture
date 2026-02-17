require "rails_helper"

describe ButtonVideoProcessingRequest, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:parent_request) }
    it { is_expected.to belong_to(:command_request) }
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
          .to eq(COSTS[:videos][processor.to_sym])
      end
    end
  end

  describe "PROCESSOR_TYPES" do
    it "contains allowed processors" do
      expect(described_class::PROCESSOR_TYPES)
        .to contain_exactly("kling_2_1_pro_image_to_video")
    end
  end
end
