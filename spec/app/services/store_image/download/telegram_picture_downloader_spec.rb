require "rails_helper"

describe StoreImage::Download::TelegramPictureDownloader do
  subject(:download_picture) { described_class.call(picture_id:) }

  let(:picture_id) { "pic_123" }
  let(:file_path_fetcher) { instance_double(StoreImage::Download::TelegramFilePathFetcher, file_path: "photos/image.jpg") }
  let(:response) { instance_double(Faraday::Response, success?: true, status: 200, body: "telegram-image-bytes") }

  before do
    allow(ENV).to receive(:fetch).with("TELEGRAM_BOT_TOKEN").and_return("telegram-token")
    allow(StoreImage::Download::TelegramFilePathFetcher)
      .to receive(:new)
      .with(picture_id:)
      .and_return(file_path_fetcher)
    allow(Faraday).to receive(:get).and_return(response)
  end

  it "returns downloaded image bytes" do
    expect(download_picture).to eq("telegram-image-bytes")
  end

  context "when Telegram file download fails" do
    let(:response) { instance_double(Faraday::Response, success?: false, status: 404, body: "") }

    it "raises descriptive error" do
      expect { download_picture }.to raise_error("Telegram picture download failed: 404")
    end
  end
end
