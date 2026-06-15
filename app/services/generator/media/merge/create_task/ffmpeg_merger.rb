module Generator
  module Media
    module Merge
      module CreateTask
        class FfmpegMerger
          AUDIO_OFFSET_MS = 1000

          def initialize(video_path:, audio_path:, output_path:)
            @video_path = video_path
            @audio_path = audio_path
            @output_path = output_path
          end

          def call
            _stdout, stderr, status = Open3.capture3(*cmd)

            raise "ffmpeg failed: #{stderr}" unless status.success?
          end

          private

          attr_reader :video_path, :audio_path, :output_path

          def cmd
            [
              "ffmpeg", "-y",
              "-i", video_path,
              "-i", audio_path,
              "-filter_complex", "[1:a]adelay=#{AUDIO_OFFSET_MS}:all=1[a]",
              "-map", "0:v",
              "-map", "[a]",
              "-c:v", "copy",
              output_path
            ]
          end
        end
      end
    end
  end
end
