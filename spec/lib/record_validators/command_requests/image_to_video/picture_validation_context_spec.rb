require "rails_helper"

describe RecordValidators::CommandRequests::ImageToVideo::PictureValidationContext do
  subject(:context) do
    described_class.new(
      picture_id:,
      width:,
      height:,
      size_bytes:
    )
  end

  let(:picture_id) { "pic_123" }
  let(:width) { 960 }
  let(:height) { 1280 }
  let(:size_bytes) { 500_000 }

  it "stores all provided attributes" do
    expect(context.picture_id).to eq(picture_id)
    expect(context.width).to eq(width)
    expect(context.height).to eq(height)
    expect(context.size_bytes).to eq(size_bytes)
  end
end
