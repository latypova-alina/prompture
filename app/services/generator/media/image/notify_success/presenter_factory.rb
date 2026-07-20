module Generator::Media::Image::NotifySuccess
  class PresenterFactory
    include Memery

    def initialize(image_url:, request:, balance:)
      @image_url = image_url
      @request = request
      @balance = balance
    end

    delegate :presenter, to: :presenter_selector

    private

    attr_reader :image_url, :request, :balance

    delegate :locale, :humanized_process_name, :processor, to: :request

    delegate :command_request, to: :request

    memoize :command_request

    def presenter_selector
      MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::PresenterSelector.new(
        context:
      )
    end

    def context
      MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::Context.new(
        image_url:,
        command_request:,
        command_request_classname:,
        locale:,
        balance:,
        processor_name: humanized_process_name,
        processor:
      )
    end

    def command_request_classname
      command_request.class.name
    end
  end
end
