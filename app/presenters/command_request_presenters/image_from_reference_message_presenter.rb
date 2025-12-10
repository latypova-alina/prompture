module CommandRequestPresenters
  class ImageToVideoMessagePresenter
    include MessageInterface

    def initialize(image_from_reference_request)
      @image_from_reference_request = image_from_reference_request
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

    attr_reader :image_from_reference_request

    def reply_text
      I18n.t("telegram_webhooks.start.image_from_reference") if image_from_reference_request.reference_picture_id.blank?

      I18n.t("telegram_webhooks.message.provide_prompt")
    end
  end
end
