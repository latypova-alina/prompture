module MediaGenerator
  module ButtonHandler
    class SendGenerationTask
      include Interactor
      include Memery

      delegate :button_request, :button_request_record, :command_request, to: :context

      def call
        return perform_audio_generator_job if audio_request?
        return perform_merge_generator_job if merge_request?

        case button_request
        when Generator::Processors::PROMPT_EXTENSION
          perform_prompt_extension_job
        when *Generator::Processors::ALL_IMAGE
          perform_image_generator_job
        when *Generator::Processors::VIDEO
          perform_video_generator_job
        end
      end

      private

      delegate :user, to: :command_request

      def perform_prompt_extension_job
        if Flipper[:improve_prompt_with_freepik].enabled?(user)
          ::Generator::Media::Prompt::TaskCreatorJob.perform_async(button_request_id)
        else
          ::Generator::Prompt::ExtendJob.perform_async(button_request_id)
        end
      end

      def perform_image_generator_job
        Generator::Media::Image::TaskCreatorJob.perform_async(button_request_id)
      end

      def perform_video_generator_job
        Generator::Media::Video::TaskCreatorJob.perform_async(button_request_id)
      end

      def perform_audio_generator_job
        Generator::Media::Audio::TaskCreatorJob.perform_async(button_request_id)
      end

      def perform_merge_generator_job
        Generator::Media::Merge::TaskCreatorJob.perform_async(button_request_id)
      end

      def audio_request?
        button_request_record.is_a?(ButtonAudioProcessingRequest)
      end

      def merge_request?
        button_request_record.is_a?(ButtonMergeAudioVideoProcessingRequest)
      end

      memoize def button_request_id
        button_request_record.id
      end
    end
  end
end
