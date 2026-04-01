module Buttons
  module ForImageMessage
    class ForImageToVideo < Buttons::Base
      include MediaInterface

      def build
        [
          *build_processors_for_media
        ]
      end

      private

      def media_scope
        "generate_video"
      end
    end
  end
end
