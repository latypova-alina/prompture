module MediaGenerator
  module ButtonHandler
    class SendGenerationTask
      include Interactor
      include Memery

      delegate :button_request, :button_request_record, to: :context

      def call
        case button_request
        when Generator::Processors::PROMPT_EXTENSION
          perform_prompt_extension_job
        when *Generator::Processors::IMAGE
          perform_image_generator_job
        when *Generator::Processors::VIDEO
          perform_video_generator_job
        end
      end

      private

      def perform_prompt_extension_job
        ::Generator::Prompt::ExtendJob.perform_async(button_request_id)
      end

      def perform_image_generator_job
        Generator::Image::TaskCreatorJob.perform_async(button_request_id)
      end

      def perform_video_generator_job
        Generator::Video::TaskCreatorJob.perform_async(button_request_id)
      end

      memoize def button_request_id
        button_request_record.id
      end
    end
  end
end
