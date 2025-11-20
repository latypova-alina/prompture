module Generator
  class ErrorNotifierJob
    include Sidekiq::Job

    IMAGE_BUTTON_REQUESTS = %w[mystic_image gemini_image imagen_image].freeze

    VIDEO_BUTTON_REQUESTS = %w[kling_2_1_pro_image_to_video].freeze

    def perform(button_request, chat_id)
      case button_request
      when *IMAGE_BUTTON_REQUESTS
        Generator::Image::ErrorNotifierJob.perform_async(chat_id)
      when *VIDEO_BUTTON_REQUESTS
        Generator::Video::ErrorNotifierJob.perform_async(chat_id)
      end
    end
  end
end
