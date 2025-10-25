module BuildImage
  class CreateTask
    include Memery
    include Interactor

    TASK_CREATOR = {
      "mystic_image" => Clients::Generator::Image::Mystic::TaskCreator,
      "gemini_image" => Clients::Generator::Image::Gemini::TaskCreator,
      "imagen_image" => Clients::Generator::Image::Imagen::TaskCreator
    }.freeze

    delegate :prompt, :processor_type, to: :context

    def call
      context.task_id = task_id
    end

    private

    delegate :task_id, to: :client

    memoize def client
      TASK_CREATOR[processor_type].new(prompt)
    end
  end
end
