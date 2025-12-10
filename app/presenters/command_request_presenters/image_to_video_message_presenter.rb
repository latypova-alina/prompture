module CommandRequestPresenters
  class ImageToVideoMessagePresenter
    include MessageInterface

    def initialize(image_to_video_request)
      @image_to_video_request = image_to_video_request
    end

    def formatted_text
      <<~HTML
        #{reply_text}
      HTML
    end

    def inline_keyboard
      nil
    end

    private

    attr_reader :image_to_video_request

    def reply_text
      I18n.t("telegram_webhooks.start.image_to_video") if image_to_video_request.reference_picture_id.blank?

      I18n.t("telegram_webhooks.message.provide_prompt")
    end
  end
end
