require "rails_helper"

describe StoreImage::Upload::ModerationValidator do
  subject(:validate!) { described_class.new(bytes:, content_type:).validate! }

  let(:bytes) { "image-bytes" }
  let(:content_type) { "image/jpeg" }

  before do
    allow(Moderation::OpenaiImageModeration).to receive(:flagged?).with(bytes:, content_type:).and_return(flagged)
  end

  context "when the image is flagged" do
    let(:flagged) { true }

    it "raises ModerationError" do
      expect { validate! }.to raise_error(ModerationError)
    end
  end

  context "when the image is not flagged" do
    let(:flagged) { false }

    it "does not raise" do
      expect { validate! }.not_to raise_error
    end
  end
end
