module Buttons
  module ForImageMessage
    class ForImageToVideo < Buttons::Base
      def build
        processor_rows
      end

      private

      def processor_rows
        media_processors.map { |processor| [button_for(:generate_video, processor)] }
      end

      def media_processors
        COSTS[:generate_video].keys - %i[seedance_1_5_pro_image_to_video]
      end
    end
  end
end
