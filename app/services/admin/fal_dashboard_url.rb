module Admin
  # Link to a button request's page in the fal dashboard:
  # https://fal.ai/models/<model endpoint>/requests/<fal_request_id>
  # The model endpoint comes from the payload strategy the request was submitted with (its API_URL
  # minus the queue host), so a new processor gets a working link automatically. Returns nil when
  # there's no fal_request_id or the processor doesn't go through fal.
  class FalDashboardUrl
    include Memery

    BASE_URL = "https://fal.ai/models".freeze
    QUEUE_HOST = "https://queue.fal.run/".freeze

    STRATEGIES = [
      Generator::Media::Image::CreateTask::StrategySelector::STRATEGIES,
      Generator::Media::Video::CreateTask::StrategySelector::STRATEGIES,
      Generator::Media::Audio::CreateTask::StrategySelector::STRATEGIES
    ].reduce(:merge).freeze

    def initialize(button_request)
      @button_request = button_request
    end

    def url
      return if fal_request_id.blank? || model_endpoint.nil?

      "#{BASE_URL}/#{model_endpoint}/requests/#{fal_request_id}"
    end

    private

    attr_reader :button_request

    def fal_request_id
      button_request.try(:fal_request_id)
    end

    memoize def model_endpoint
      STRATEGIES[button_request.try(:processor)]&.const_get(:API_URL)&.delete_prefix(QUEUE_HOST)
    end
  end
end
