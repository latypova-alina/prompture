module Buttons
  module ForPromptMessage
    class ForFirstLastFrameToVideo < Buttons::Base
      PROCESSOR = "kling_3_standard_image_to_video".freeze

      def build
        [[button_for(:generate_video, PROCESSOR)]]
      end
    end
  end
end
