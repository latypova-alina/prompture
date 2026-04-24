module Buttons
  module ForImageMessage
    class ForPromptToVideo < Buttons::Base
      def initialize(processor:, **kwargs)
        super(**kwargs)
        @processor = processor
      end

      def build
        [regenerate_row, *processor_rows]
      end

      private

      attr_reader :processor

      def regenerate_row
        [regenerate_button]
      end

      def regenerate_button
        regenerate_button_for(:generate_image, processor)
      end

      def processor_rows
        media_processors.map { |processor| [button_for(:generate_video, processor)] }
      end

      def media_processors
        COSTS[:generate_video].keys
      end
    end
  end
end
