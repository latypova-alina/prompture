require "rails_helper"

describe Generator::Media::StoredMedia::AudioUploader do
  subject(:service) { described_class.new(media_url:, record:) }

  let(:media_url) { "https://v3b.fal.media/files/b/generated.mp3" }
  let(:record) { create(:button_audio_processing_request) }
  let(:uploaded_url) { "https://internal.example/audio/generated.mp3" }
  let(:upload_facade) { instance_double(StoreMedia::Upload::Facade, stored_url: uploaded_url) }

  before do
    allow(StoreImage::Download::RemoteUrlDownloader)
      .to receive(:new)
      .with(media_url)
      .and_return(instance_double(StoreImage::Download::RemoteUrlDownloader, downloaded_bytes: "audio-bytes"))

    allow(StoreMedia::Upload::Facade)
      .to receive(:new)
      .with(bytes: "audio-bytes", filename: "generated.mp3", folder: "audio")
      .and_return(upload_facade)

    allow(upload_facade).to receive(:upload)
  end

  describe "#call" do
    it "uploads to audio folder and updates record" do
      service.call

      expect(upload_facade).to have_received(:upload)
      expect(record.reload.audio_url).to eq(uploaded_url)
    end
  end
end
