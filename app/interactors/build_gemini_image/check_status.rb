module BuildGeminiImage
  class CheckStatus
    include Memery
    include Interactor

    delegate :task_id, to: :context

    FINISHED_STATUS = "COMPLETED".freeze
    FAILED_STATUS = "FAILED".freeze
    SLEEP_INTERVAL  = 3
    MAX_ATTEMPTS    = (5 * 60 / SLEEP_INTERVAL).freeze

    def call
      MAX_ATTEMPTS.times do
        sleep SLEEP_INTERVAL

        case status
        when FINISHED_STATUS
          context.image_url = gemini_client.image_url
          return
        when FAILED_STATUS
          raise Gemini::ImageGenerationFailed
        end
      end

      raise Gemini::ImageGenerationTimeout
    end

    private

    delegate :status, to: :gemini_client

    memoize def gemini_client
      Clients::Gemini::TaskRetriever.new(task_id)
    end
  end
end
