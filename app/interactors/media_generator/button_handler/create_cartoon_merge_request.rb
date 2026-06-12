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
      delegate :command_request, to: :button_video_processing_request
      delegate :stored_video, to: :button_video_processing_request
      delegate :video_url, to: :stored_video

      memoize :video_url

      memoize def button_merge_audio_video_processing_request
        ButtonMergeAudioVideoProcessingRequest.create!(
          status: "PENDING",
          parent_request: audio_request,
          processor: PROCESSOR,
          source_video_url: video_url,
          source_audio_url: audio_url,
          command_request:
        )
      end
    end
  end
end
