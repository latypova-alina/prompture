module Buttons
  module ForImageMessage
    class ForPromptToImage < Buttons::Base
      def initialize(processor:, **kwargs)
        super(**kwargs)
        @processor = processor
      end

      def build
        [[regenerate_button]]
      end

      private

      attr_reader :processor

      def regenerate_button
        regenerate_button_for(:generate_image, processor)
      end
    end
  end
end
