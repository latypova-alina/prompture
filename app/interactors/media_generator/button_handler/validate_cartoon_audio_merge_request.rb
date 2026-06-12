module MediaGenerator
  module ButtonHandler
    class ValidateCartoonAudioMergeRequest
      include Interactor
      include Memery

      def call
        context.fail!(error: CommandUnknownError) unless mergeable?
      end

      private

      delegate :command_request, :audio_request, :button_video_processing_request, to: :context
      delegate :audio_prompt, :audio_url, :status, to: :audio_request

      def mergeable?
        command_request.cartoon_script? &&
          audio_request.is_a?(ButtonAudioProcessingRequest) &&
          audio_prompt.present? &&
          audio_url.present? &&
          status == "COMPLETED" &&
          button_video_processing_request&.persisted_video_url.present?
      end
    end
  end
end
