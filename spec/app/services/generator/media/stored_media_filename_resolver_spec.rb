require "rails_helper"

describe Generator::Media::StoredMedia::FilenameResolver do
  subject(:resolver) { described_class.new(media_url:) }

  describe "#filename" do
    context "when url path includes file extension" do
      let(:media_url) { "https://ai-statics.freepik.com/content/image.png?token=abc" }

      it "returns basename from url path" do
        expect(resolver.filename).to eq("image.png")
      end
    end

    context "when url points to video file" do
      let(:media_url) { "https://cdn-magnific.freepik.com/kling_abcd1234.mp4?token=abc" }

      it "returns video filename basename" do
        expect(resolver.filename).to eq("kling_abcd1234.mp4")
      end
    end
  end
end
