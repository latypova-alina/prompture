require "fastimage"

module StoreImage
  module Upload
    class ImageDimensionsValidator
      MIN_RESOLUTION_PX = 300

      def initialize(bytes:)
        @bytes = bytes
      end

      def validate!
        raise ImageResolutionError if width.nil? || height.nil?

        return if valid_resolution?

        raise ImageResolutionError
      end

      private

      attr_reader :bytes

      def image_dimensions
        FastImage.size(StringIO.new(bytes))
      end

      def width
        image_dimensions.first
      end

      def height
        image_dimensions.last
      end

      def valid_resolution?
        width >= MIN_RESOLUTION_PX && height >= MIN_RESOLUTION_PX
      end
    end
  end
end
