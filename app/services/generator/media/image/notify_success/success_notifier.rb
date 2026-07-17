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

      enqueue_next_chained_scene
    end

    private

    attr_reader :image_url, :button_request_id

    delegate :reply_data, to: :presenter
    delegate :presenter, to: :presenter_factory
    delegate :user, to: :request
    delegate :balance, to: :user
    delegate :credits, to: :balance, prefix: true

    def send_telegram_message
      SendTelegramMessage.call(reply_data:, request:)
    end

    def update_request_status
      request.update!(status: "COMPLETED", image_url:)
    end

    def enqueue_next_chained_scene
      ScriptGenerator::ForCartoon::EnqueueNextChainedScene.call(
        image_url:,
        button_request: request
      )
    end

    def presenter_factory
      PresenterFactory.new(image_url:, request:, balance: balance_credits)
    end

    memoize def request
      ButtonImageProcessingRequest.includes(
        { parent_request: :bot_telegram_message },
        { command_request: { user: :balance } }
      ).find(button_request_id)
    end
  end
end
