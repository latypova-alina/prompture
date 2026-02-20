module Buttons
  module ForImageMessage
    class ForPromptToVideo < Buttons::Base
      def build
        [
          *build_processors_for_media
        ]
      end

      private

      def scope
        "generate_video"
      end

      def type
        :videos
      end
    end
  end
end
