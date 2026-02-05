require "rails_helper"

describe RecordCreators::ButtonRequests::Images::Gemini do
  subject { described_class.new(parent_request, command_request).record }

  let(:command_request) { create(:command_prompt_to_image_request) }
  let(:parent_request) { command_request }

  it "creates a pending image processing request with gemini processor" do
    expect { subject }.to change(ButtonImageProcessingRequest, :count).by(1)

    record = ButtonImageProcessingRequest.last

    expect(record.status).to eq("PENDING")
    expect(record.processor).to eq("gemini_image")
    expect(record.parent_request).to eq(parent_request)
    expect(record.command_request).to eq(command_request)
  end
end
