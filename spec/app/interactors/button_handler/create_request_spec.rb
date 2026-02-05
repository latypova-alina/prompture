require "rails_helper"

describe ButtonHandler::CreateRequest do
  subject do
    described_class.call(
      button_request:,
      parent_request:,
      command_request:,
      image_url:
    )
  end

  let(:button_request) { "mystic_image" }
  let(:image_url) { "https://example.com/image.png" }

  let(:parent_request) { instance_double("ParentRequest") }
  let(:command_request) { instance_double("CommandRequest") }

  let(:record_creator_class) { RecordCreators::ButtonRequests::Images::Mystic }
  let(:record_creator) { instance_double(record_creator_class, record:) }
  let(:record) { instance_double("ButtonImageProcessingRequest") }

  before do
    allow(record_creator_class)
      .to receive(:new)
      .with(parent_request, command_request, image_url)
      .and_return(record_creator)
  end

  it "uses the correct handler" do
    result = subject

    expect(result).to be_success
    expect(result.button_request_record).to eq(record)

    expect(record_creator_class)
      .to have_received(:new)
      .with(parent_request, command_request, image_url)
  end
end
