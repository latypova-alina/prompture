module Generator::Media::Merge::NotifySuccess
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

    attr_reader :video_url, :button_request_id

    delegate :reply_data, to: :presenter
    delegate :user, to: :request
    delegate :balance, to: :user
    delegate :credits, to: :balance, prefix: true
    delegate :locale, :humanized_process_name, to: :request

    def send_telegram_message
      SendTelegramMessage.call(reply_data:, request:)
    end

    def update_request_status
      request.update!(status: "COMPLETED", video_url:)
    end

    memoize def presenter
      MediaGenerator::ButtonRequestPresenters::MergeProcessedMessagePresenter.new(
        message: video_url,
        balance: balance_credits,
        locale:,
        processor_name: humanized_process_name
      )
    end

    memoize def request
      ButtonMergeAudioVideoProcessingRequest.includes({ parent_request: :bot_telegram_message },
                                                      command_request: { user: :balance }).find(button_request_id)
    end
  end
end
