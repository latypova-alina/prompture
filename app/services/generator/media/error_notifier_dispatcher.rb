module Generator
  module Media
    class ErrorNotifierDispatcher
      include Memery

      def self.call(...)
        new(...).call
      end

      def initialize(processor:, button_request_id:, error_reason: nil, flagged_message: nil)
        @processor = processor
        @button_request_id = button_request_id
        @error_reason = error_reason
        @flagged_message = flagged_message
      end

      attr_reader :processor, :button_request_id, :error_reason, :flagged_message

      def call
        case processor
        when Generator::Processors::PROMPT_EXTENSION
          Generator::Prompt::ErrorNotifierJob.perform_async(button_request_id)
        when *Generator::Processors::ALL_IMAGE
          notify(Generator::Media::Image::ErrorNotifierJob)
        when *Generator::Processors::VIDEO
          notify(Generator::Media::Video::ErrorNotifierJob)
        when *Generator::Processors::AUDIO
          notify(Generator::Media::Audio::ErrorNotifierJob)
        when *Generator::Processors::MERGE
          notify(Generator::Media::Merge::ErrorNotifierJob)
        end
      end

      private

      def notify(job_class)
        job_class.perform_async(button_request_id, error_reason, flagged_message)
      end
    end
  end
end
