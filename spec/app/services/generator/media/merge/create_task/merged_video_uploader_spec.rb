require "rails_helper"

describe Generator::Media::Merge::CreateTask::MergedVideoUploader do
  subject(:stored_url) { described_class.new(tmp:, request:).stored_url }

  let(:request) { create(:button_merge_audio_video_processing_request) }
  let(:tmp) do
    Tempfile.new(["merged", ".mp4"]).tap do |f|
      f.binmode
      f.write("video bytes")
      f.rewind
    end
  end
  let(:stored_url_value) { "https://s3.example.com/merged_#{request.id}.mp4" }
  let(:facade) { instance_double(StoreMedia::Upload::Facade, upload: nil, stored_url: stored_url_value) }

  before do
    allow(StoreMedia::Upload::Facade).to receive(:new).and_return(facade)
  end

  after { tmp.close! }

  it "uploads with the correct filename and folder" do
    stored_url

    expect(StoreMedia::Upload::Facade).to have_received(:new).with(
      bytes: "video bytes",
      filename: "merged_#{request.id}.mp4",
      folder: ContentCategory.merged_video_bucket_folder(request.command_request.category)
    )
  end

  it "returns the stored url" do
    expect(stored_url).to eq(stored_url_value)
  end
end
