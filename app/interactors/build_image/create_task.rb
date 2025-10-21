module BuildImage
  class CreateTask
    include Memery
    include Interactor

    TASK_CREATOR = {
      "mystic_image" => Clients::ImageGenerator::MysticTaskCreator,
      "gemini_image" => Clients::ImageGenerator::GeminiTaskCreator,
      "imagen_image" => Clients::ImageGenerator::ImagenTaskCreator
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
