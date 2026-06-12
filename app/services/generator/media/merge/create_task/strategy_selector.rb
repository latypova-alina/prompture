module Generator
  module Media
    module Merge
      module CreateTask
        class StrategySelector
          include Memery

          STRATEGIES = {
            "ffmpeg_merge_audio_video" => FfmpegMergeAudioVideoPayloadStrategy
          }.freeze

          def initialize(request)
            @request = request
          end

          def strategy
            strategies.fetch(processor).new(video_url:, audio_url:)
          end

          private

          attr_reader :request

          delegate :processor, :source_video_url, :source_audio_url, to: :request

          alias video_url source_video_url
          alias audio_url source_audio_url

          def strategies
            STRATEGIES
          end
        end
      end
    end
  end
end
