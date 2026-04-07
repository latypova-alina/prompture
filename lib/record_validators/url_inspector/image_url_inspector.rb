require "uri"

module RecordValidators
  module UrlInspector
    class ImageUrlInspector
      include Memery

      def initialize(image_url:)
        @image_url = image_url
      end

      def valid?
        return false unless parsed_uri

        return true if trusted?

        simple_valid? && fetchable?
      end

      private

      attr_reader :image_url

      memoize def parsed_uri
        URI.parse(image_url)
      rescue URI::InvalidURIError
        nil
      end

      def trusted?
        TrustedSourceValidator.new(uri: parsed_uri).valid?
      end

      def simple_valid?
        SimpleImageUrlValidator.new(uri: parsed_uri).valid?
      end

      def fetchable?
        FetchableUrlValidator.new(url: image_url).valid?
      end
    end
  end
end
