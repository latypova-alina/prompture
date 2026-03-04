module Generator::Media::Image::NotifySuccess
  class SuccessNotifier
    include Memery

    def self.call(...)
      new(...).call
    end

    def initialize(image_url:, button_request_id:)
      @image_url = image_url
      @button_request_id = button_request_id
    end

    def call
      send_telegram_message

      update_request_status
    end

    private

    attr_reader :image_url, :button_request_id

    delegate :reply_data, to: :presenter
    delegate :presenter, to: :presenter_selector

    def send_telegram_message
      SendTelegramMessage.call(reply_data:, request:)
    end

    def update_request_status
      request.update!(status: "COMPLETED", image_url:)
    end

    def presenter_selector
      PresenterSelector.new(image_url:, request:)
    end

    memoize def request
      ButtonImageProcessingRequest.includes(:parent_request, command_request: :user).find(button_request_id)
    end
  end
end
