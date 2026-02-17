require "rails_helper"

describe RecordCreators::ButtonRequests::Videos::Kling do
  subject { described_class.new(parent_request, command_request, image_url).record }

  let(:image_url) { "https://example.com/image.jpg" }
  let(:command_request) { create(:command_prompt_to_video_request) }
  let(:parent_request) do
    create(:button_image_processing_request, image_url:, command_request:)
  end

  it "creates a pending video processing request with kling processor" do
    expect { subject }.to change(ButtonVideoProcessingRequest, :count).by(1)

    record = ButtonVideoProcessingRequest.last

    expect(record.status).to eq("PENDING")
    expect(record.processor).to eq("kling_2_1_pro_image_to_video")
    expect(record.parent_request).to eq(parent_request)
    expect(record.command_request).to eq(command_request)
  end

  context "when image_url is missing" do
    let(:image_url) { nil }

    it "raises an ImageForgottenError" do
      expect { subject }.to raise_error(ImageForgottenError)
    end
  end
end
