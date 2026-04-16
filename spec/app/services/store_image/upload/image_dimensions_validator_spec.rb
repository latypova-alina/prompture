require "rails_helper"

describe StoreImage::Upload::ImageDimensionsValidator do
  subject(:validate!) { described_class.new(bytes:).validate! }

  let(:bytes) { "image-bytes" }
  let(:io) { instance_double(StringIO) }

  before do
    allow(StringIO).to receive(:new).with(bytes).and_return(io)
  end

  context "when image dimensions are at least 300x300" do
    before do
      allow(FastImage).to receive(:size).with(io).and_return([300, 301])
    end

    it "passes validation" do
      expect { validate! }.not_to raise_error
    end
  end

  context "when image dimensions are lower than 300x300" do
    before do
      allow(FastImage).to receive(:size).with(io).and_return([299, 600])
    end

    it "raises ImageResolutionError" do
      expect { validate! }.to raise_error(ImageResolutionError)
    end
  end

  context "when dimensions cannot be determined" do
    before do
      allow(FastImage).to receive(:size).with(io).and_return([nil, nil])
    end

    it "raises ImageResolutionError" do
      expect { validate! }.to raise_error(ImageResolutionError)
    end
  end
end
