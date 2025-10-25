module Strategies
  class GenerateVideo
    include Interface

    def initialize(session, processor_type)
      @image_url = session["image_url"]
      @session = session
      @processor_type = processor_type
    end

    delegate :reply_data, to: :presenter

    private

    attr_reader :image_url, :processor_type, :session

    delegate :video_url, to: :video_processor

    def presenter
      raise ImageForgottenError if image_url.blank?

      ButtonMessagePresenter.new(video_url, "video_message", processor_type)
    end

    def video_processor
      VideoProcessor.new(image_url, processor_type)
    end
  end
end
