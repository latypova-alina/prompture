module StoreImage
  module Upload
    class ModerationValidator
      include Memery

      def initialize(bytes:, content_type:, moderatable:)
        @bytes = bytes
        @content_type = content_type
        @moderatable = moderatable
      end

      def validate!
        raise ModerationError if blocked?
      end

      private

      attr_reader :bytes, :content_type, :moderatable

      delegate :blocked?, to: :moderation_result
      delegate :command_request, to: :moderatable

      memoize def moderation_result
        Moderation::RecordedCheck.call(moderation: Moderation::OpenaiImageModeration.new(bytes:, content_type:), input:)
      end

      def input
        Moderation::Input.new(input_kind: "image", command_request:, moderatable:)
      end
    end
  end
end
