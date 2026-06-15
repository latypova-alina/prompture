require "rails_helper"

describe Generator::Media::StoredMedia::FilenameResolver do
  subject(:resolver) { described_class.new(media_url:) }

  describe "#filename" do
    context "when url path includes file extension" do
      let(:media_url) { "https://v3b.fal.media/files/b/generated.png?token=abc" }

      it "returns basename from url path" do
        expect(resolver.filename).to eq("generated.png")
      end
    end

    context "when url points to video file" do
      let(:media_url) { "https://v3b.fal.media/files/b/kling_abcd1234.mp4?token=abc" }

      it "returns video filename basename" do
        expect(resolver.filename).to eq("kling_abcd1234.mp4")
      end
    end
  end
end
