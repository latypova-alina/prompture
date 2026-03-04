module Generator::Media::Image::NotifySuccess
  class PresenterSelector
    def initialize(image_url:, request:)
      @image_url = image_url
      @request = request
    end

    delegate :presenter, to: :presenter_selector

    private

    attr_reader :image_url, :request

    delegate :locale, to: :request

    def presenter_selector
      MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::PresenterSelector.new(
        image_url, command_request_classname, locale
      )
    end

    def command_request_classname
      request.command_request.class.name
    end
  end
end
