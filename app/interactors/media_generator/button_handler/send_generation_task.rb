module MediaGenerator
  module ButtonHandler
    class SendGenerationTask
      include Interactor
      include Memery

      delegate :button_request, :button_request_record, :image_url, to: :context

      PROMPT_EXTENSION_PROCESS_NAME = "extend_prompt".freeze

      IMAGE_PROCESSORS = %w[mystic_image gemini_image imagen_image].freeze

      VIDEO_GENERATOR_JOBS = {
        "kling_2_1_pro_image_to_video" => Generator::Video::Kling::TaskCreatorJob
      }.freeze

      def call
        case button_request
        when PROMPT_EXTENSION_PROCESS_NAME
          perform_prompt_extension_job
        when *IMAGE_PROCESSORS
          perform_image_generator_job
        when *VIDEO_GENERATOR_JOBS.keys
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
        VIDEO_GENERATOR_JOBS[button_request].perform_async(button_request_id, image_url)
      end

      memoize def button_request_id
        button_request_record.id
      end
    end
  end
end
