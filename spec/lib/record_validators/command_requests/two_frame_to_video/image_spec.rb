require "rails_helper"
require "ostruct"

describe RecordValidators::CommandRequests::TwoFrameToVideo::Image do
  subject(:validator) { described_class.new(context:, command_request:) }

  let(:command_request) { create(:command_two_frame_to_video_request) }
  let(:context) do
    OpenStruct.new(
      picture_id:,
      image_url:,
      width:,
      height:,
      size_bytes:
    )
  end
  let(:picture_id) { "AgACAgIAAxkBAAIB..." }
  let(:image_url) { nil }
  let(:width) { 960 }
  let(:height) { 1280 }
  let(:size_bytes) { 500.kilobytes }
  let(:image_url_validator) do
    instance_double(
      RecordValidators::CommandRequests::ImageUrlValidator,
      valid?: false,
      invalid?: false
    )
  end
  let(:picture_validator) do
    instance_double(RecordValidators::CommandRequests::PictureValidator, valid?: true)
  end
  let(:file_validator) do
    instance_double(RecordValidators::CommandRequests::ImageToVideo::FileValidator, valid?: false)
  end

  before do
    allow(RecordValidators::CommandRequests::ImageUrlValidator)
      .to receive(:new)
      .with(image_url:)
      .and_return(image_url_validator)

    allow(RecordValidators::CommandRequests::PictureValidator)
      .to receive(:new)
      .and_return(picture_validator)

    allow(RecordValidators::CommandRequests::ImageToVideo::FileValidator)
      .to receive(:new)
      .with(picture_id:, size_bytes:)
      .and_return(file_validator)
  end

  it "does not raise when a picture is valid and frames are not ready" do
    expect { validator.validate }.not_to raise_error
  end

  context "when both frames are already ready" do
    let(:command_request) do
      create(
        :command_two_frame_to_video_request,
        start_image_url: "https://example.com/start.png",
        end_image_url: "https://example.com/end.png"
      )
    end

    it "raises MessageTypeError" do
      expect { validator.validate }.to raise_error(MessageTypeError)
    end
  end
end
