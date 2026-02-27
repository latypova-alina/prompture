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

    def initialize(context)
      @context = context
    end

    def call
      return unless RETRIEVER_JOBS.key?(processor)

      RETRIEVER_JOBS[processor].perform_async(task_id, button_request_id)
    end

    private

    attr_reader :context

    delegate :task_id, :processor, :button_request_id, to: :context
  end
end
