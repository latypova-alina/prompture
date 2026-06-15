module MediaGenerator
  module ButtonHandler
    class SendGenerationTask
      include Interactor
      include Memery

      BUTTON_REQUEST_JOB_CLASSES = {
        ButtonAudioProcessingRequest => Generator::Media::Audio::TaskCreatorJob,
        ButtonMergeAudioVideoProcessingRequest => Generator::Media::Merge::TaskCreatorJob
      }.freeze

      delegate :button_request, :button_request_record, :command_request, to: :context

      def call
        return unless job_class

        job_class.perform_async(button_request_record.id)
      end

      private

      memoize def job_class
        record_job_class || processor_job_class
      end

      def record_job_class
        BUTTON_REQUEST_JOB_CLASSES[button_request_record.class]
      end

      def processor_job_class
        case button_request
        when Generator::Processors::PROMPT_EXTENSION
          Generator::Prompt::ExtendJob
        when *Generator::Processors::ALL_IMAGE
          Generator::Media::Image::TaskCreatorJob
        when *Generator::Processors::VIDEO
          Generator::Media::Video::TaskCreatorJob
        end
      end
    end
  end
end
