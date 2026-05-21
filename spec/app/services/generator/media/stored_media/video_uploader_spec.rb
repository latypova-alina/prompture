require "rails_helper"

describe Generator::Media::StoredMedia::VideoUploader do
  subject(:service) { described_class.new(media_url:, record:) }

  let(:media_url) { "https://ai-statics.freepik.com/generated.mp4" }
  let(:record) do
    create(
      :button_video_processing_request,
      command_request: create(:command_prompt_to_video_request, :motivation)
    )
  end
  let(:uploaded_url) { "https://internal.example/videos/motivation/generated.mp4" }
  let(:upload_facade) { instance_double(StoreMedia::Upload::Facade, stored_url: uploaded_url) }

  before do
    allow(StoreImage::Download::UrlImageDownloader)
      .to receive(:call)
      .with(media_url)
      .and_return("video-bytes")

    allow(StoreMedia::Upload::Facade)
      .to receive(:new)
      .with(bytes: "video-bytes", filename: "generated.mp4", folder: "videos/motivation")
      .and_return(upload_facade)

    allow(upload_facade).to receive(:upload)
  end

  describe "#call" do
    it "uploads to category folder and updates record" do
      service.call

      expect(upload_facade).to have_received(:upload)
      expect(record.reload.video_url).to eq(uploaded_url)
    end
  end
end
