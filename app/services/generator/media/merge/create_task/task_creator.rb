module Generator
  module Media
    module Merge
      module CreateTask
        class TaskCreator
          include Memery

          def initialize(request)
            @request = request
          end

          memoize def url
            video_tmp  = download(source_video_url, ".mp4")
            audio_tmp  = download(source_audio_url, ".mp3")
            output_tmp = Tempfile.new(["merged", ".mp4"])

            FfmpegMerger.new(
              video_path: video_tmp.path,
              audio_path: audio_tmp.path,
              output_path: output_tmp.path
            ).call

            upload(output_tmp)
          ensure
            [video_tmp, audio_tmp, output_tmp].each { |f| f&.close! }
          end

          private

          attr_reader :request

          delegate :source_video_url, :source_audio_url, to: :request

          def download(url, ext)
            MediaDownloader.new(url, ext).tempfile
          end

          def upload(tmp)
            MergedVideoUploader.new(tmp:, request:).stored_url
          end
        end
      end
    end
  end
end
