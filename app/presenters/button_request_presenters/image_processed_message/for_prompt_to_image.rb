module ButtonRequestPresenters
  module ImageProcessedMessage
    class ForPromptToImage < BasePresenter
      include MessageInterface

      def formatted_text
        "<a href=\"#{message}\">Open image</a>"
      end

      def inline_keyboard
        Buttons::ForImageMessage::ForPromptToImage::BUTTONS
      end
    end
  end
end
