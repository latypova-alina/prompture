require "rails_helper"

describe RecordCreators::ButtonRequests::Videos::Seedance do
  subject(:record) { described_class.new(parent_request, command_request).record }

  let(:image_url) { "https://example.com/image.jpg" }
  let(:command_request) { create(:command_prompt_to_video_request) }
  let(:parent_request) do
    create(:button_image_processing_request, image_url:, command_request:)
  end

  it "creates a pending video processing request with seedance processor" do
    expect { record }.to change(ButtonVideoProcessingRequest, :count).by(1)

    created_record = ButtonVideoProcessingRequest.last

    expect(created_record.status).to eq("PENDING")
    expect(created_record.processor).to eq("seedance_1_5_pro_image_to_video")
    expect(created_record.parent_request).to eq(parent_request)
    expect(created_record.command_request).to eq(command_request)
  end

  context "when image_url is missing" do
    let(:image_url) { nil }

    it "raises an ImageNotReadyError" do
      expect { record }.to raise_error(ImageNotReadyError)
    end
  end
end
