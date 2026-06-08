require "rails_helper"

describe RecordCreators::ButtonRequests::Videos::Kling do
  subject(:create_request) do
    described_class.new(prompt_message, command_request).record
  end

  let(:command_request) { create(:command_image_to_video_request) }
  let(:picture_message) do
    create(:user_picture_message, command_request:, parent_request: command_request)
  end
  let(:prompt_message) do
    create(
      :prompt_message,
      prompt: "ocean waves",
      command_request:,
      parent_request: picture_message
    )
  end

  before do
    create(:stored_image, source_message: picture_message, image_url: "https://example.com/image.png")
  end

  it "creates video request using the image from the prompt parent chain" do
    expect { create_request }.to change(ButtonVideoProcessingRequest, :count).by(1)

    record = ButtonVideoProcessingRequest.last
    expect(record.image_url).to eq("https://example.com/image.png")
    expect(record.parent_request).to eq(prompt_message)
  end
end
