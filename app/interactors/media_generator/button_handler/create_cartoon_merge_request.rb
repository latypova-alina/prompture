module MediaGenerator
  module ButtonHandler
    class CreateCartoonMergeRequest
      include Interactor
      include Memery

      PROCESSOR = "ffmpeg_merge_audio_video".freeze

      def call
        context.button_request_record = button_merge_audio_video_processing_request
        context.button_request = PROCESSOR
      end

      private

      delegate :audio_request, :button_video_processing_request, to: :context
      delegate :audio_url, to: :audio_request
      delegate :command_request, :persisted_video_url, to: :button_video_processing_request

      memoize def button_merge_audio_video_processing_request
        ButtonMergeAudioVideoProcessingRequest.create!(
          status: "PENDING",
          parent_request: audio_request,
          processor: PROCESSOR,
          source_video_url: persisted_video_url,
          source_audio_url: audio_url,
          command_request:
        )
      end
    end
  end
end
