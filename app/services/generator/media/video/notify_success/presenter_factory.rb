module Generator::Media::Video::NotifySuccess
  class PresenterFactory
    def initialize(video_url:, request:, balance:)
      @video_url = video_url
      @request = request
      @balance = balance
    end

    delegate :presenter, to: :presenter_selector

    private

    attr_reader :video_url, :request, :balance

    delegate :locale, :humanized_process_name, :processor, to: :request
    delegate :command_request, to: :request

    def presenter_selector
      MediaGenerator::ButtonRequestPresenters::VideoProcessedMessage::PresenterSelector.new(
        context:
      )
    end

    def context
      MediaGenerator::ButtonRequestPresenters::VideoProcessedMessage::Context.new(
        video_url:,
        command_request:,
        locale:,
        balance:,
        processor_name: humanized_process_name,
        processor:
      )
    end
  end
end
