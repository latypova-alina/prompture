module Generator
  class TaskRetrieverDispatcher
    RETRIEVER_JOBS = {
      "mystic_image" => Image::Mystic::TaskRetrieverJob,
      "gemini_image" => Image::Gemini::TaskRetrieverJob,
      "imagen_image" => Image::Imagen::TaskRetrieverJob,
      "kling_2_1_pro_image_to_video" => Generator::Video::Kling::TaskRetrieverJob

    }.freeze

    def self.call(...)
      new(...).call
    end

    def initialize(task_id:, button_request:, request_id:, chat_id:)
      @task_id = task_id
      @button_request = button_request
      @request_id = request_id
      @chat_id = chat_id
    end

    attr_reader :task_id, :button_request, :request_id, :chat_id

    def call
      return unless RETRIEVER_JOBS.key?(button_request)

      RETRIEVER_JOBS[button_request].perform_async(task_id, chat_id, request_id)
    end
  end
end
