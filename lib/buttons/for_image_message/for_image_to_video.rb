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
        COSTS[:generate_video].keys
      end
    end
  end
end
