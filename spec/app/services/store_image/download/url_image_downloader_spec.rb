require "rails_helper"

describe StoreImage::Download::UrlImageDownloader do
  subject(:call_downloader) { described_class.call(url) }

  let(:url) { "https://example.com/image.jpg" }
  let(:response) { instance_double(Faraday::Response, success?: success, status: 200, body: "image-bytes") }
  let(:success) { true }

  before do
    allow(Faraday).to receive(:get).with(url).and_return(response)
  end

  it "returns response body when request succeeds" do
    expect(call_downloader).to eq("image-bytes")
  end

  context "when request fails" do
    let(:success) { false }
    let(:response) { instance_double(Faraday::Response, success?: false, status: 404, body: "") }

    it "raises descriptive error" do
      expect { call_downloader }.to raise_error("Image download failed: 404")
    end
  end
end
