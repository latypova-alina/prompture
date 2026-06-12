module MediaGenerator
  module ButtonHandler
    class CreateCartoonMergeRequest
      include Interactor
      include Memery

      PROCESSOR = "ffmpeg_merge_audio_video".freeze

      delegate :parent_request, to: :context

      def call
        context.button_request_record = button_merge_audio_video_processing_request
        context.button_request = PROCESSOR
      end

      private

      delegate :chat_id, :user, to: :command_request
      delegate :audio_url, to: :parent_request
      delegate :command_request, to: :parent_request

      memoize def button_merge_audio_video_processing_request
        ButtonMergeAudioVideoProcessingRequest.create!(
          status: "PENDING",
          parent_request:,
          processor: PROCESSOR,
          source_video_url: stored_video_url,
          source_audio_url: audio_url,
          command_request: command_prompt_to_video_request
        )
      end

      memoize def command_prompt_to_video_request
        CommandPromptToVideoRequest.create!(
          chat_id:,
          user:,
          category: ContentCategory::CARTOON_SCRIPT
        )
      end

      memoize def stored_video_url
        video_request.stored_video.video_url
      end

      memoize def video_request
        parent_request.parent_request
      end
    end
  end
end
