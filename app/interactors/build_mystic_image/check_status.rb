module BuildMysticImage
  class CheckStatus
    include Memery
    include Interactor

    delegate :task_id, to: :context

    FINISHED_STATUS = "COMPLETED".freeze
    FAILED_STATUS = "FAILED".freeze

    def call
      loop do
        sleep 3

        if status == FINISHED_STATUS
          context.image_url = mystic_client.image_url
          break
        end

        raise Mystic::ImageGenerationFailed if status == FAILED_STATUS
      end
    end

    private

    delegate :status, to: :mystic_client

    memoize def mystic_client
      Clients::Mystic::TaskRetriever.new(task_id)
    end
  end
end
