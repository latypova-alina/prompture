require "rails_helper"

describe Generator::Media::Merge::CreateTask::FfmpegMerger do
  subject(:call) do
    described_class.new(
      video_path: video_path,
      audio_path: audio_path,
      output_path: output_path
    ).call
  end

  let(:video_path) { "/tmp/video.mp4" }
  let(:audio_path) { "/tmp/audio.mp3" }
  let(:output_path) { "/tmp/output.mp4" }

  context "when ffmpeg succeeds" do
    before do
      allow(Open3).to receive(:capture3).and_return(["", "", instance_double(Process::Status, success?: true)])
    end

    it "calls ffmpeg with the correct command" do
      call

      expect(Open3).to have_received(:capture3).with(
        "ffmpeg", "-y",
        "-i", video_path,
        "-i", audio_path,
        "-filter_complex", "[1:a]adelay=1000:all=1[a]",
        "-map", "0:v",
        "-map", "[a]",
        "-c:v", "copy",
        output_path
      )
    end
  end

  context "when ffmpeg fails" do
    before do
      allow(Open3).to receive(:capture3).and_return(["", "some error", instance_double(Process::Status, success?: false)])
    end

    it "raises an error" do
      expect { call }.to raise_error(RuntimeError, /ffmpeg failed/)
    end
  end
end
