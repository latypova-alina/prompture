module RecordValidators
  module CommandRequests
    class ImageToVideo
      include Memery

      def initialize(picture_id:, image_url:)
        @picture_id = picture_id
        @image_url = image_url
      end

      def validate
        raise ImageUrlInvalid if image_url_check_invalid?
        raise MessageTypeError unless valid_message_type?
      end

      private

      attr_reader :picture_id, :image_url

      delegate :valid?, :invalid?, to: :image_url_check, prefix: true
      delegate :valid?, to: :picture_check, prefix: true

      def valid_message_type?
        image_url_check_valid? || picture_check_valid?
      end

      memoize def image_url_check
        ImageUrlValidator.new(image_url:)
      end

      memoize def picture_check
        PictureValidator.new(picture_id:)
      end
    end
  end
end
