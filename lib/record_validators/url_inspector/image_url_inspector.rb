require "uri"

module RecordValidators
  module UrlInspector
    class ImageUrlInspector
      ALLOWED_IMAGE_MEDIA_TYPES = %w[
        image/jpeg
        image/jpg
        image/png
      ].freeze

      def initialize(image_url:)
        @image_url = image_url
      end

      def valid?
        uri = URI.parse(image_url)
        return false unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)

        allowed_image_content_type?(head_response(uri)) || allowed_image_content_type?(range_response(uri))
      rescue URI::InvalidURIError
        false
      end

      private

      attr_reader :image_url

      def head_response(uri)
        HeadRequester.new(uri:).run
      end

      def range_response(uri)
        RangeRequester.new(uri:).run
      end

      def allowed_image_content_type?(response)
        raw = response&.headers&.[]("content-type")&.split(";")&.first
        return false if raw.blank?

        ALLOWED_IMAGE_MEDIA_TYPES.include?(raw.strip.downcase)
      end
    end
  end
end
