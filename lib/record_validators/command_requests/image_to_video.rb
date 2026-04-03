module RecordValidators
  module CommandRequests
    class ImageToVideo
      include Memery

      def initialize(picture_id:, image_url:)
        @picture_id = picture_id
        @image_url = image_url
      end

      def validate
        raise ImageUrlInvalid if image_url_invalid?
        raise MessageTypeError unless valid_message_type?
      end

      private

      attr_reader :picture_id, :image_url

      def valid_message_type?
        image_url_provided? || picture_provided?
      end

      def picture_provided?
        picture_id.present?
      end

      def image_url_provided?
        image_url.present? && image_url_valid?
      end

      def image_url_invalid?
        image_url.present? && !image_url_valid?
      end

      memoize def image_url_valid?
        image_url_inspector.valid?
      end

      def image_url_inspector
        RecordValidators::UrlInspector::ImageUrlInspector.new(image_url:)
      end
    end
  end
end
