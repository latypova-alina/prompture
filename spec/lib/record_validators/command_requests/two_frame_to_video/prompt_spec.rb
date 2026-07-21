require "rails_helper"

describe RecordValidators::CommandRequests::TwoFrameToVideo::Prompt do
  subject(:validate) { described_class.new(command_request:, message_text:, picture_id:).validate }

  let(:command_request) do
    create(
      :command_two_frame_to_video_request,
      awaiting_video_prompt: true,
      start_image_url: "https://example.com/start.png",
      end_image_url: "https://example.com/end.png"
    )
  end
  let(:message_text) { "smooth transition" }
  let(:picture_id) { nil }

  it "does not raise" do
    expect { validate }.not_to raise_error
  end

  context "when not awaiting video prompt" do
    let(:command_request) do
      create(
        :command_two_frame_to_video_request,
        awaiting_video_prompt: false,
        start_image_url: "https://example.com/start.png",
        end_image_url: "https://example.com/end.png"
      )
    end

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

  context "when frames are not ready" do
    let(:command_request) do
      create(
        :command_two_frame_to_video_request,
        awaiting_video_prompt: true,
        start_image_url: "https://example.com/start.png",
        end_image_url: nil
      )
    end

    it "raises ImageNotReadyError" do
      expect { validate }.to raise_error(ImageNotReadyError)
    end
  end
end
