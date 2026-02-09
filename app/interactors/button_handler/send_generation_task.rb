module ButtonHandler
  class SendGenerationTask
    include Interactor
    include Memery

    delegate :button_request, :button_request_record, :image_url, :chat_id, :parent_request, to: :context
    delegate :parent_prompt, to: :parent_request

    PROMPT_EXTENSION_JOBS = {
      "extend_prompt" => ::Generator::Prompt::ExtendJob
    }.freeze

    IMAGE_GENERATOR_JOBS = {
      "mystic_image" => ::Generator::Image::Mystic::TaskCreatorJob,
      "gemini_image" => ::Generator::Image::Gemini::TaskCreatorJob,
      "imagen_image" => ::Generator::Image::Imagen::TaskCreatorJob
    }.freeze

    VIDEO_GENERATOR_JOBS = {
      "kling_2_1_pro_image_to_video" => Generator::Video::Kling::TaskCreatorJob
    }.freeze

    def call
      case button_request
      when *PROMPT_EXTENSION_JOBS.keys
        perform_prompt_extension_job
      when *IMAGE_GENERATOR_JOBS.keys
        perform_image_generator_job
      when *VIDEO_GENERATOR_JOBS.keys
        perform_video_generator_job
      end
    end

    private

    def perform_prompt_extension_job
      PROMPT_EXTENSION_JOBS[button_request].perform_async(parent_prompt, chat_id, button_request_id)
    end

    def perform_image_generator_job
      IMAGE_GENERATOR_JOBS[button_request].perform_async(parent_prompt, chat_id, button_request, button_request_id)
    end

    def perform_video_generator_job
      VIDEO_GENERATOR_JOBS[button_request].perform_async(parent_prompt, image_url, chat_id, button_request,
                                                         button_request_id)
    end

    memoize def button_request_id
      button_request_record.id
    end
  end
end
