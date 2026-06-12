module Generator
  module Media
    module Merge
      module CreateTask
        class FfmpegMergeAudioVideoPayloadStrategy
          API_URL = "https://queue.fal.run/fal-ai/ffmpeg-api/merge-audio-video".freeze
          START_OFFSET = 1

          def initialize(video_url:, audio_url:)
            @video_url = video_url
            @audio_url = audio_url
          end

          def payload
            {
              video_url:,
              audio_url:,
              start_offset: START_OFFSET
            }
          end

          def api_url
            API_URL
          end

          private

          attr_reader :video_url, :audio_url
        end
      end
    end
  end
end
