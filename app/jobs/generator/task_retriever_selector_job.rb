module Generator
  class TaskRetrieverSelectorJob
    include Sidekiq::Job

    RETRIEVER_JOBS = {
      "mystic_image" => Image::Mystic::TaskRetrieverJob,
      "gemini_image" => Image::Gemini::TaskRetrieverJob,
      "imagen_image" => Image::Imagen::TaskRetrieverJob
      # "kling_2_1_pro_image_to_video" => Generator::Video::Kling::TaskRetrieverJob

    }.freeze

    def perform(task_id, button_request, chat_id)
      RETRIEVER_JOBS[button_request].perform_async(task_id, chat_id)
    end
  end
end
