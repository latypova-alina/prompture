module Generator::Media::Video::NotifySuccess
  class SuccessNotifier
    include Memery

    def self.call(...)
      new(...).call
    end

    def initialize(video_url:, button_request_id:)
      @video_url = video_url
      @button_request_id = button_request_id
    end

    def call
      send_telegram_message

      update_request_status
    end

    private

    delegate :reply_data, to: :presenter
    attr_reader :video_url, :button_request_id

    def send_telegram_message
      SendTelegramMessage.call(reply_data:, request:)
    end

    def update_request_status
      request.update!(status: "COMPLETED", video_url:)
    end

    memoize def presenter
      MediaGenerator::ButtonRequestPresenters::VideoProcessedMessagePresenter.new(message: video_url)
    end

    memoize def request
      ButtonVideoProcessingRequest.includes(:parent_request, command_request: :user).find(button_request_id)
    end
  end
end
