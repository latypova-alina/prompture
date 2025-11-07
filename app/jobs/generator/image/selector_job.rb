module Generator
  module Image
    class SelectorJob
      include Sidekiq::Job

      TASK_CREATOR_JOBS = {
        "mystic_image" => Image::Mystic::TaskCreatorJob,
        "gemini_image" => Image::Gemini::TaskCreatorJob,
        "imagen_image" => Image::Imagen::TaskCreatorJob
      }.freeze

      def perform(session, processor_type, chat_id)
        prompt = session["image_prompt"]

        TASK_CREATOR_JOBS[processor_type].perform_async(prompt, chat_id)
      end
    end
  end
end
