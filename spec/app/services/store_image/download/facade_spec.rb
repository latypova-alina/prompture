require "rails_helper"

describe StoreImage::Download::Facade do
  describe "#bytes and #filename" do
    context "when record is ImageUrlMessage" do
      let(:record) { create(:image_url_message, image_url: "https://example.com/image.jpg") }
      let(:downloaded_bytes) { "url-image-bytes" }
      subject(:facade) { described_class.new(record) }

      before do
        allow(StoreImage::Download::UrlImageDownloader)
          .to receive(:call)
          .with(record.image_url)
          .and_return(downloaded_bytes)
      end

      it "returns bytes from UrlImageDownloader" do
        expect(facade.bytes).to eq(downloaded_bytes)
      end

      it "returns generated filename for image url message" do
        expect(facade.filename).to eq("image_url_#{record.id}.jpg")
      end
    end

    context "when record is PictureMessage" do
      let(:record) { create(:picture_message, picture_id: "pic_123") }
      let(:downloaded_bytes) { "telegram-image-bytes" }
      subject(:facade) { described_class.new(record) }

      before do
        allow(StoreImage::Download::TelegramPictureDownloader)
          .to receive(:call)
          .with(picture_id: "pic_123")
          .and_return(downloaded_bytes)
      end

      it "returns bytes from TelegramPictureDownloader" do
        expect(facade.bytes).to eq(downloaded_bytes)
      end

      it "returns generated filename for picture message" do
        expect(facade.filename).to eq("picture_#{record.id}.jpg")
      end
    end
  end
end
