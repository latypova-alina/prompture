module BuildImage
  class CheckStatus
    include Memery
    include Interactor

    delegate :task_id, :processor_type, to: :context

    TASK_RETRIEVER = {
      "mystic_image" => Clients::ImageGenerator::MysticTaskRetriever,
      "gemini_image" => Clients::ImageGenerator::GeminiTaskRetriever,
      "imagen_image" => Clients::ImageGenerator::ImagenTaskRetriever
    }.freeze

    FINISHED_STATUS = "COMPLETED".freeze
    FAILED_STATUS = "FAILED".freeze
    SLEEP_INTERVAL  = 3
    MAX_ATTEMPTS    = (5 * 60 / SLEEP_INTERVAL).freeze

    def call
      MAX_ATTEMPTS.times do
        sleep SLEEP_INTERVAL

        case status
        when FINISHED_STATUS
          context.image_url = client.image_url
          return
        when FAILED_STATUS
          raise Freepik::ImageGenerationFailed
        end
      end

      raise Freepik::ImageGenerationTimeout
    end

    private

    delegate :status, to: :client

    memoize def client
      TASK_RETRIEVER[context.processor_type].new(task_id)
    end
  end
end
