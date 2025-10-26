module BuildVideo
  class CheckStatus
    include Memery
    include Interactor

    delegate :task_id, :processor_type, to: :context

    TASK_RETRIEVER = {
      "kling_2_1_pro_image_to_video" => Clients::Generator::Video::Kling::TaskRetriever
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
          context.video_url = client.video_url
          return
        when FAILED_STATUS
          raise Freepik::VideoGenerationFailed
        end
      end

      raise Freepik::VideoGenerationTimeout
    end

    private

    delegate :status, to: :client

    memoize def client
      TASK_RETRIEVER[context.processor_type].new(task_id)
    end
  end
end
