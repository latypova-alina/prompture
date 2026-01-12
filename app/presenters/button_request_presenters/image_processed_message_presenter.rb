module ButtonRequestPresenters
  class ImageProcessedMessagePresenter < BasePresenter
    include MessageInterface

    def formatted_text
      "<a href=\"#{message}\">Open image</a>"
    end

    def inline_keyboard
      Buttons::ForImageMessage::BUTTONS
    end
  end
end
