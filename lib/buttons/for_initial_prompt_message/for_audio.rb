module Buttons
  module ForInitialPromptMessage
    class ForAudio < Base
      def build
        processor_rows
      end

      private

      def processor_rows
        media_processors.map { |processor| [button_for(:generate_audio, processor)] }
      end

      def media_processors
        COSTS[:generate_audio].keys
      end
    end
  end
end
