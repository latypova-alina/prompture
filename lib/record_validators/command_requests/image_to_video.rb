module RecordValidators
  module CommandRequests
    class ImageToVideo
      include Memery

      def initialize(context:)
        @context = context
      end

      def validate
        raise ImageUrlInvalid if image_url_check_invalid?
        raise MessageTypeError unless valid_message_type?
      end

      private

      attr_reader :context

      delegate :picture_id, :image_url, :width, :height, :size_bytes, to: :context

      delegate :valid?, :invalid?, to: :image_url_check, prefix: true
      delegate :valid?, to: :picture_check, prefix: true
      delegate :valid?, to: :file_check, prefix: true

      def valid_message_type?
        image_url_check_valid? || picture_check_valid? || file_check_valid?
      end

      memoize def image_url_check
        ImageUrlValidator.new(image_url:)
      end

      memoize def picture_check
        PictureValidator.new(context: picture_validation_context)
      end

      memoize def file_check
        FileValidator.new(picture_id:, size_bytes:)
      end

      def picture_validation_context
        PictureValidationContext.new(
          picture_id:,
          width:,
          height:,
          size_bytes:
        )
      end
    end
  end
end
