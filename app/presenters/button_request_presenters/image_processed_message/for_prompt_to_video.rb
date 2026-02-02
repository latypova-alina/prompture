module ButtonRequestPresenters
  module ImageProcessedMessage
    class ForPromptToVideo < BasePresenter
      include MessageInterface

      def formatted_text
        "<a href=\"#{message}\">Open image</a>"
      end

      def inline_keyboard
        Buttons::ForImageMessage::ForPromptToVideo::BUTTONS
      end
    end
  end
end
