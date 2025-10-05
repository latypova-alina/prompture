module Strategies
  class GenerateImage
    include Interface

    def initialize(session, processor_type)
      @prompt = session["prompt"]
      @session = session
      @processor_type = processor_type

      update_session
    end

    delegate :reply_data, to: :presenter

    private

    attr_reader :prompt, :processor_type, :session

    delegate :image_url, to: :image_processor

    def presenter
      ButtonMessagePresenter.new(image_url, "image_message", processor_type, session["regenerate"])
    end

    def image_processor
      ImageProcessor.new(prompt, processor_type)
    end

    def update_session
      session["regenerate"] = true
    end
  end
end