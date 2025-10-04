module Strategies
  class GenerateImage
    include Interface

    def initialize(prompt, processor_type)
      @prompt = prompt
      @processor_type = processor_type
    end

    delegate :reply_data, to: :presenter

    private

    delegate :image_url, to: :image_processor

    def presenter
      ButtonMessagePresenter.new(image_url, "image_message", processor_type)
    end

    def image_processor
      ImageProcessor.new(prompt, processor_type)
    end

    attr_reader :prompt, :processor_type
  end
end