module Buttons
  module ForImageMessage
    class ForEditImage < Buttons::Base
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
        regenerate_button_for(:edit_image, processor)
      end
    end
  end
end
