require "rails_helper"

describe Generator::Media::Image::RetrieveTask::ImageExtractor do
  subject(:media_url) { described_class.new(response).media_url }

  let(:response) { double(success?: success, body:) }

  describe "#media_url" do
    context "when response is successful" do
      let(:success) { true }
      let(:body) do
        {
          data: {
            generated: ["http://example.com/image.png"]
          }
        }.to_json
      end

      it "returns the generated image url" do
        expect(media_url).to eq("http://example.com/image.png")
      end
    end

    context "when response is not successful" do
      let(:success) { false }
      let(:body) { "{}" }

      it "raises Freepik::ResponseError" do
        expect { media_url }.to raise_error(Freepik::ResponseError)
      end
    end
  end
end
