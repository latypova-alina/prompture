module Generator
  class ErrorNotifierDispatcher
    IMAGE_BUTTON_REQUESTS = %w[mystic_image gemini_image imagen_image].freeze

    VIDEO_BUTTON_REQUESTS = %w[kling_2_1_pro_image_to_video].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(button_request:, chat_id:)
      @button_request = button_request
      @chat_id = chat_id
    end

    attr_reader :button_request, :chat_id

    def call
      case button_request
      when *IMAGE_BUTTON_REQUESTS
        Generator::Image::ErrorNotifierJob.perform_async(chat_id)
      when *VIDEO_BUTTON_REQUESTS
        Generator::Video::ErrorNotifierJob.perform_async(chat_id)
      end
    end
  end
end
