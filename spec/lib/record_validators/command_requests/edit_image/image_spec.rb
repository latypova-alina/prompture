require "rails_helper"
require "ostruct"

describe RecordValidators::CommandRequests::EditImage::Image do
  subject(:validator) { described_class.new(context:) }

  let(:context) do
    OpenStruct.new(
      picture_id: "AgACAgIAAxkBAAIB...",
      image_url: nil,
      width: 960,
      height: 1280,
      size_bytes: 500.kilobytes
    )
  end

  before do
    allow(RecordValidators::CommandRequests::ImageUrlValidator)
      .to receive(:new)
      .and_return(instance_double(RecordValidators::CommandRequests::ImageUrlValidator, valid?: false, invalid?: false))

    allow(RecordValidators::CommandRequests::PictureValidator)
      .to receive(:new)
      .and_return(instance_double(RecordValidators::CommandRequests::PictureValidator, valid?: true))

    allow(RecordValidators::CommandRequests::ImageToVideo::FileValidator)
      .to receive(:new)
      .and_return(instance_double(RecordValidators::CommandRequests::ImageToVideo::FileValidator, valid?: false))
  end

  it { expect(described_class).to be < RecordValidators::CommandRequests::ImageToVideo }

  it "validates image messages like ImageToVideo" do
    expect { validator.validate }.not_to raise_error
  end
end
