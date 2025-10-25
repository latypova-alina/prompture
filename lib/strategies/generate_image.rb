module Strategies
  class GenerateImage
    include Interface

    def initialize(session, processor_type)
      @prompt = session["image_prompt"]
      @session = session
      @processor_type = processor_type

      update_session
    end

    delegate :reply_data, to: :presenter

    private

    attr_reader :prompt, :processor_type, :session

    delegate :image_url, to: :image_processor

    def presenter
      raise PromptForgottenError if prompt.blank?

      ButtonMessagePresenter.new(image_url, "image_message", processor_type)
    end

    def update_session
      session["image_url"] = image_url
    end

    def image_processor
      ImageProcessor.new(prompt, processor_type)
    end
  end
end
