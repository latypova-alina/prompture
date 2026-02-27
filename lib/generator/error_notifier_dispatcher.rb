module Generator
  class ErrorNotifierDispatcher
    include Memery

    IMAGE_PROCESSORS = %w[mystic_image gemini_image imagen_image].freeze

    VIDEO_PROCESSORS = %w[kling_2_1_pro_image_to_video].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(processor:, button_request_id:)
      @processor = processor
      @button_request_id = button_request_id
    end

    attr_reader :processor, :button_request_id

    def call
      case processor
      when *IMAGE_PROCESSORS
        Generator::Image::ErrorNotifierJob.perform_async(button_request_id)
      when *VIDEO_PROCESSORS
        Generator::Video::ErrorNotifierJob.perform_async(button_request_id)
      end
    end
  end
end
