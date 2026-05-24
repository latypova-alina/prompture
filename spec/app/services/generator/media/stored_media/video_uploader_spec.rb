require "rails_helper"

describe Generator::Media::StoredMedia::VideoUploader do
  subject(:service) { described_class.new(media_url:, record:) }

  let(:media_url) { "https://ai-statics.freepik.com/generated.mp4" }
  let(:command_request) { create(:command_prompt_to_video_request, :motivation) }
  let(:prompt_message) do
    create(:prompt_message, command_request:, parent_request: command_request, subcategory: "cry")
  end
  let(:parent_request) { create(:button_image_processing_request, command_request:, parent_request: prompt_message) }
  let(:record) { create(:button_video_processing_request, command_request:, parent_request:) }
  let(:uploaded_url) { "https://internal.example/videos/motivation/cry/generated.mp4" }
  let(:upload_facade) { instance_double(StoreMedia::Upload::Facade, stored_url: uploaded_url) }

  let(:remote_url_downloader) { instance_double(StoreImage::Download::RemoteUrlDownloader, downloaded_bytes: "video-bytes") }

  before do
    allow(StoreImage::Download::RemoteUrlDownloader)
      .to receive(:new)
      .with(media_url)
      .and_return(remote_url_downloader)

    allow(StoreMedia::Upload::Facade)
      .to receive(:new)
      .with(bytes: "video-bytes", filename: "generated.mp4", folder: "videos/motivation/cry")
      .and_return(upload_facade)

    allow(upload_facade).to receive(:upload)
    allow(StoreVideo::Registrar).to receive(:call)
  end

  describe "#call" do
    it "uploads to category and subcategory folder and updates record" do
      service.call

      expect(upload_facade).to have_received(:upload)
      expect(record.reload.video_url).to eq(uploaded_url)
    end

    it "registers stored video" do
      service.call

      expect(StoreVideo::Registrar).to have_received(:call).with(record:, video_url: uploaded_url)
    end

    context "when subcategory is missing" do
      let(:prompt_message) do
        create(:prompt_message, command_request:, parent_request: command_request, subcategory: nil)
      end
      let(:uploaded_url) { "https://internal.example/videos/motivation/generated.mp4" }

      before do
        allow(StoreMedia::Upload::Facade)
          .to receive(:new)
          .with(bytes: "video-bytes", filename: "generated.mp4", folder: "videos/motivation")
          .and_return(upload_facade)
      end

      it "uploads to category folder only" do
        service.call

        expect(upload_facade).to have_received(:upload)
      end
    end
  end
end
