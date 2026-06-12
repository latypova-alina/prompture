module MediaGenerator
  module ButtonHandler
    class ValidateCartoonAudioMergeRequest
      include Interactor
      include Memery

      delegate :command_request, :parent_request, to: :context

      def call
        context.fail!(error: CommandUnknownError) unless mergeable?
      end

      private

      def mergeable?
        command_request.cartoon_script? &&
          parent_request.is_a?(ButtonAudioProcessingRequest) &&
          parent_request.audio_prompt.present? &&
          parent_request.audio_url.present? &&
          parent_request.status == "COMPLETED" &&
          stored_video_url.present?
      end

      memoize def stored_video_url
        video_request&.stored_video&.video_url
      end

      memoize def video_request
        return unless parent_request.parent_request.is_a?(ButtonVideoProcessingRequest)

        parent_request.parent_request
      end
    end
  end
end
