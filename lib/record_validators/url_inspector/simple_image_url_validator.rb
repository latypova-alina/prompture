module RecordValidators
  module UrlInspector
    class SimpleImageUrlValidator
      def initialize(uri:)
        @uri = uri
      end

      def valid?
        return false unless http_or_https?

        uri.path.match?(/\.(jpg|jpeg|png)$/i)
      end

      private

      attr_reader :uri

      def http_or_https?
        uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      end
    end
  end
end
