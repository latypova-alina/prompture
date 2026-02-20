module ButtonRequestPresenters
  class VideoProcessedMessagePresenter < BasePresenter
    include MessageInterface

    def formatted_text
      "<a href=\"#{message}\">Open video</a>"
    end

    def inline_keyboard
      Buttons::ForVideoMessage.build
    end
  end
end
