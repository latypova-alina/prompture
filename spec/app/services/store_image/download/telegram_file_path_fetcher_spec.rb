require "rails_helper"

describe StoreImage::Download::TelegramFilePathFetcher do
  subject(:fetch_file_path) { described_class.new(picture_id:).file_path }

  let(:picture_id) { "pic_123" }
  let(:bot_token) { "telegram-token" }
  let(:response) { instance_double(Faraday::Response, success?: true, status: 200, body: response_body) }
  let(:response_body) { { ok: true, result: { file_path: "photos/image.jpg" } }.to_json }

  before do
    allow(ENV).to receive(:fetch).with("TELEGRAM_BOT_TOKEN").and_return(bot_token)
    allow(Faraday).to receive(:get).and_return(response)
  end

  it "returns file_path from Telegram getFile response" do
    expect(fetch_file_path).to eq("photos/image.jpg")
  end

  context "when Telegram request fails" do
    let(:response) { instance_double(Faraday::Response, success?: false, status: 500, body: "") }

    it "raises descriptive error" do
      expect { fetch_file_path }.to raise_error("Telegram getFile failed: 500")
    end
  end

  context "when Telegram response has ok=false" do
    let(:response_body) { { ok: false }.to_json }

    it "raises invalid response error" do
      expect { fetch_file_path }.to raise_error("Telegram getFile response invalid")
    end
  end

  context "when file_path is missing in response" do
    let(:response_body) { { ok: true, result: {} }.to_json }

    it "raises missing file_path error" do
      expect { fetch_file_path }.to raise_error("Telegram file_path missing")
    end
  end
end
