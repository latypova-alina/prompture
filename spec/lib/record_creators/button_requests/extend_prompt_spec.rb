require "rails_helper"

describe RecordCreators::ButtonRequests::ExtendPrompt do
  subject { described_class.new(parent_request, command_request).record }

  let(:command_request) { create(:command_prompt_to_image_request) }
  let(:parent_request) { command_request }

  it "creates a pending extend prompt request" do
    expect { subject }.to change(ButtonExtendPromptRequest, :count).by(1)

    record = ButtonExtendPromptRequest.last

    expect(record.status).to eq("PENDING")
    expect(record.parent_request).to eq(parent_request)
    expect(record.command_request).to eq(command_request)
  end
end
