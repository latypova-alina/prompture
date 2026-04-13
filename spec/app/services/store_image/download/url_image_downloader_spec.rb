require "rails_helper"

describe StoreImage::Download::UrlImageDownloader do
  subject(:call_downloader) { described_class.call(url) }

  let(:url) { "https://example.com/image.jpg" }
  let(:downloaded_file) { StringIO.new("image-bytes") }

  before do
    allow(URI).to receive(:open).and_return(downloaded_file)
  end

  it "returns file bytes when request succeeds" do
    expect(call_downloader).to eq("image-bytes")
  end

  it "downloads with browser-like headers" do
    call_downloader

    expect(URI).to have_received(:open).with(
      url,
      {
        "User-Agent" => described_class::BROWSER_USER_AGENT,
        "Referer" => described_class::BROWSER_REFERER
      }
    )
  end

  context "when request fails" do
    let(:error_io) { double("OpenUriErrorIo", status: %w[404 Not Found]) }
    let(:error) { OpenURI::HTTPError.new("404 Not Found", error_io) }

    before do
      allow(URI).to receive(:open).and_raise(error)
    end

    it "raises descriptive error" do
      expect { call_downloader }.to raise_error("Image download failed: 404")
    end
  end
end
