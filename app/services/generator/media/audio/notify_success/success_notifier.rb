module Generator::Media::Audio::NotifySuccess
  class SuccessNotifier
    include Memery

    PARENT_REQUEST_INCLUDES = %i[bot_telegram_message stored_video].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(audio_url:, button_request_id:)
      @audio_url = audio_url
      @button_request_id = button_request_id
    end

    def call
      send_telegram_message

      update_request_status
    end

    private

    attr_reader :audio_url, :button_request_id

    delegate :reply_data, to: :presenter
    delegate :user, to: :request
    delegate :balance, to: :user
    delegate :credits, to: :balance, prefix: true
    delegate :locale, :humanized_process_name, :processor, to: :request

    def send_telegram_message
      SendTelegramMessage.call(reply_data:, request:)
    end

    def update_request_status
      request.update!(status: "COMPLETED", audio_url:)
    end

    memoize def presenter
      MediaGenerator::ButtonRequestPresenters::AudioProcessedMessage::PresenterSelector.new(
        request:,
        message: audio_url,
        balance: balance_credits,
        processor_name: humanized_process_name,
        processor:
      ).presenter
    end

    memoize def request
      ButtonAudioProcessingRequest.includes({ parent_request: PARENT_REQUEST_INCLUDES },
                                            command_request: { user: :balance }).find(button_request_id)
    end
  end
end
