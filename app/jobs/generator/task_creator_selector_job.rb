module Generator
  class TaskCreatorSelectorJob
    include Sidekiq::Job

    PROMPT_EXTENSION_JOBS = {
      "extend_prompt" => Prompt::ExtendJob
    }.freeze

    IMAGE_GENERATOR_JOBS = {
      "mystic_image" => Image::Mystic::TaskCreatorJob,
      "gemini_image" => Image::Gemini::TaskCreatorJob,
      "imagen_image" => Image::Imagen::TaskCreatorJob
    }.freeze

    VIDEO_GENERATOR_JOBS = {
      "kling_2_1_pro_image_to_video" => Generator::Video::Kling::TaskCreatorJob
    }.freeze

    def perform(image_prompt, image_url, button_request, chat_id)
      case button_request
      when *PROMPT_EXTENSION_JOBS.keys
        PROMPT_EXTENSION_JOBS[button_request].perform_async(image_prompt, chat_id)
      when *IMAGE_GENERATOR_JOBS.keys
        IMAGE_GENERATOR_JOBS[button_request].perform_async(image_prompt, button_request, chat_id)
      when *VIDEO_GENERATOR_JOBS.keys
        VIDEO_GENERATOR_JOBS[button_request].perform_async(image_prompt, image_url, button_request, chat_id)
      end
    end
  end
end
