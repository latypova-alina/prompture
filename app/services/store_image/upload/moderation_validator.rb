module StoreImage
  module Upload
    class ModerationValidator
      def initialize(bytes:, content_type:)
        @bytes = bytes
        @content_type = content_type
      end

      def validate!
        raise ModerationError if flagged?
      end

      private

      attr_reader :bytes, :content_type

      def flagged?
        Moderation::OpenaiImageModeration.flagged?(bytes:, content_type:)
      end
    end
  end
end
