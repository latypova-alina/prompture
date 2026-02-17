require "rails_helper"

describe ButtonImageProcessingRequest, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:parent_request) }
    it { is_expected.to belong_to(:command_request) }
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
        COSTS[:images][processor.to_sym]
      )
    end
  end
end
