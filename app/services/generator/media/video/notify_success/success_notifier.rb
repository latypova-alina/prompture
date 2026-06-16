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
      delete_interim_message
      send_telegram_message
      update_request_status
    end

    private

    delegate :reply_data, to: :presenter
    delegate :presenter, to: :presenter_factory
    delegate :user, :interim_tg_message_id, :chat_id, to: :request
    delegate :balance, to: :user
    delegate :credits, to: :balance, prefix: true
    delegate :locale, :humanized_process_name, :processor, to: :request
    attr_reader :video_url, :button_request_id

    def delete_interim_message
      TelegramIntegration::DeleteMessage.call(
        chat_id:,
        message_id: interim_tg_message_id
      )
    end

    def send_telegram_message
      SendTelegramMessage.call(reply_data:, request:)
    end

    def update_request_status
      request.update!(status: "COMPLETED", video_url:)
    end

    def presenter_factory
      PresenterFactory.new(video_url:, request:, balance: balance_credits)
    end

    memoize def request
      ButtonVideoProcessingRequest.includes({ parent_request: :bot_telegram_message },
                                            command_request: { user: :balance }).find(button_request_id)
    end
  end
end
