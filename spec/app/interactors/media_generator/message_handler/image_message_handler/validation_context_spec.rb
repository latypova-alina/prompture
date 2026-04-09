require "rails_helper"

describe MediaGenerator::MessageHandler::ImageMessageHandler::ValidationContext do
  subject(:context) do
    described_class.new(
      picture_id:,
      image_url:,
      width:,
      height:,
      size_bytes:
    )
  end

  let(:picture_id) { "pic_123" }
  let(:image_url) { "https://example.com/image.jpg" }
  let(:width) { 1280 }
  let(:height) { 720 }
  let(:size_bytes) { 500_000 }

  it "stores all provided attributes" do
    expect(context.picture_id).to eq(picture_id)
    expect(context.image_url).to eq(image_url)
    expect(context.width).to eq(width)
    expect(context.height).to eq(height)
    expect(context.size_bytes).to eq(size_bytes)
  end
end
