require "rails_helper"

describe Generator::Media::Video::RetrieveTask::VideoExtractor do
  subject(:media_url) { described_class.new(response).media_url }

  let(:response) { double(success?: success, body:) }

  describe "#media_url" do
    context "when response is successful" do
      let(:success) { true }
      let(:body) do
        {
          data: {
            generated: ["http://example.com/video.mp4"]
          }
        }.to_json
      end

      it "returns the generated video url" do
        expect(media_url).to eq("http://example.com/video.mp4")
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
