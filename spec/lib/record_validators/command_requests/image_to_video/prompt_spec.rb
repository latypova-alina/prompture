require "rails_helper"

describe RecordValidators::CommandRequests::ImageToVideo::Prompt do
  subject(:validate) { described_class.new(command_request:, message_text:, picture_id:).validate }

  let(:command_request) { create(:command_image_to_video_request, awaiting_video_prompt: true) }
  let(:message_text) { "a cat walking" }
  let(:picture_id) { nil }

  before do
    picture_message = create(
      :user_picture_message,
      command_request:,
      parent_request: command_request
    )
    create(:stored_image, source_message: picture_message, image_url: "https://example.com/image.png")
  end

  it "does not raise" do
    expect { validate }.not_to raise_error
  end

  context "when not awaiting video prompt" do
    let(:command_request) { create(:command_image_to_video_request, awaiting_video_prompt: false) }

    it "raises MessageTypeError" do
      expect { validate }.to raise_error(MessageTypeError)
    end
  end

  context "when message is not text" do
    let(:message_text) { nil }
    let(:picture_id) { "file_123" }

    it "raises MessageTypeError" do
      expect { validate }.to raise_error(MessageTypeError)
    end
  end

  context "when image is not ready" do
    before do
      StoredImage.delete_all
    end

    it "raises ImageNotReadyError" do
      expect { validate }.to raise_error(ImageNotReadyError)
    end
  end
end
