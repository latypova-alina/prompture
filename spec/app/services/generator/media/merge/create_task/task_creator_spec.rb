require "rails_helper"

describe Generator::Media::Merge::CreateTask::TaskCreator do
  subject(:url) { described_class.new(request).url }

  let(:request) { create(:button_merge_audio_video_processing_request) }
  let(:merged_url) { "https://s3.example.com/merged.mp4" }

  let(:video_tmp) { instance_double(Tempfile, path: "/tmp/video.mp4", close!: nil) }
  let(:audio_tmp) { instance_double(Tempfile, path: "/tmp/audio.mp3", close!: nil) }
  let(:output_tmp) { instance_double(Tempfile, path: "/tmp/output.mp4", close!: nil) }

  let(:ffmpeg_merger) { instance_double(Generator::Media::Merge::CreateTask::FfmpegMerger, call: nil) }
  let(:uploader) { instance_double(Generator::Media::Merge::CreateTask::MergedVideoUploader, stored_url: merged_url) }

  before do
    allow(Generator::Media::Merge::CreateTask::MediaDownloader)
      .to receive(:new).with(request.source_video_url, ".mp4")
      .and_return(instance_double(Generator::Media::Merge::CreateTask::MediaDownloader, tempfile: video_tmp))

    allow(Generator::Media::Merge::CreateTask::MediaDownloader)
      .to receive(:new).with(request.source_audio_url, ".mp3")
      .and_return(instance_double(Generator::Media::Merge::CreateTask::MediaDownloader, tempfile: audio_tmp))

    allow(Tempfile).to receive(:new).with(["merged", ".mp4"]).and_return(output_tmp)

    allow(Generator::Media::Merge::CreateTask::FfmpegMerger)
      .to receive(:new)
      .with(video_path: video_tmp.path, audio_path: audio_tmp.path, output_path: output_tmp.path)
      .and_return(ffmpeg_merger)

    allow(Generator::Media::Merge::CreateTask::MergedVideoUploader)
      .to receive(:new).with(tmp: output_tmp, request:)
      .and_return(uploader)
  end

  it "merges video and audio and returns the stored url" do
    expect(url).to eq(merged_url)
  end

  it "cleans up all tempfiles" do
    url

    expect(video_tmp).to have_received(:close!)
    expect(audio_tmp).to have_received(:close!)
    expect(output_tmp).to have_received(:close!)
  end

  context "when ffmpeg fails" do
    before do
      allow(ffmpeg_merger).to receive(:call).and_raise(RuntimeError, "ffmpeg failed")
    end

    it "still cleans up tempfiles" do
      expect { url }.to raise_error(RuntimeError)

      expect(video_tmp).to have_received(:close!)
      expect(audio_tmp).to have_received(:close!)
      expect(output_tmp).to have_received(:close!)
    end
  end
end
