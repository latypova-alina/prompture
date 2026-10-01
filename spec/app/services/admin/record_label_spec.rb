require "rails_helper"

describe Admin::RecordLabel do
  describe ".call" do
    subject { described_class.call(record) }

    let(:record) { create(:button_image_processing_request) }

    it { is_expected.to eq("ButtonImageProcessingRequest##{record.id}") }
  end

  describe ".for" do
    subject { described_class.for("PromptMessage", 7) }

    it { is_expected.to eq("PromptMessage#7") }
  end
end
