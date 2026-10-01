require "rails_helper"

describe Admin::RecordLabel do
  subject { described_class.call(record) }

  let(:record) { create(:button_image_processing_request) }

  it { is_expected.to eq("ButtonImageProcessingRequest##{record.id}") }
end
