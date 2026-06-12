require "rails_helper"

describe Generator::Media::StoredMedia::MergedVideoUploader do
  subject(:service) { described_class.new(media_url:, record:) }

  let(:media_url) { "https://fal.media/merged.mp4" }
  let(:command_request) do
    create(:command_prompt_to_video_request, category: ContentCategory::CARTOON_SCRIPT)
  end
  let(:record) do
    create(
      :button_merge_audio_video_processing_request,
      command_request:
    )
  end
  let(:uploaded_url) { "https://internal.example/cartoon/video/with_audio/merged.mp4" }
  let(:upload_facade) { instance_double(StoreMedia::Upload::Facade, stored_url: uploaded_url) }
  let(:remote_url_downloader) do
    instance_double(StoreImage::Download::RemoteUrlDownloader, downloaded_bytes: "video-bytes")
  end

  before do
    allow(StoreImage::Download::RemoteUrlDownloader)
      .to receive(:new)
      .with(media_url)
      .and_return(remote_url_downloader)

    allow(StoreMedia::Upload::Facade)
      .to receive(:new)
      .with(bytes: "video-bytes", filename: "merged.mp4", folder: "cartoon/video/with_audio")
      .and_return(upload_facade)

    allow(upload_facade).to receive(:upload)
    allow(StoreVideo::Registrar).to receive(:call)
  end

  describe "#call" do
    it "uploads to merged video folder and updates record" do
      service.call

      expect(upload_facade).to have_received(:upload)
      expect(record.reload.video_url).to eq(uploaded_url)
    end

    it "registers stored video" do
      service.call

      expect(StoreVideo::Registrar).to have_received(:call).with(record:, video_url: uploaded_url)
    end
  end
end
