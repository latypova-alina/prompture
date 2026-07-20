module Generator::Media::Image::NotifySuccess
  class SuccessNotifierRouter
    include Memery

    def self.call(...)
      new(...).call
    end

    def initialize(image_url:, button_request_id:)
      @image_url = image_url
      @button_request_id = button_request_id
    end

    def call
      notifier_class.call(image_url:, button_request_id:)
    end

    private

    attr_reader :image_url, :button_request_id

    delegate :cartoon_shorts_complex_script?, to: :command_request

    def notifier_class
      return ForBloomy::SuccessNotifier if cartoon_shorts_complex_script?

      SuccessNotifier
    end

    memoize def command_request
      ButtonImageProcessingRequest
        .includes(:command_request)
        .find(button_request_id)
        .command_request
    end
  end
end
