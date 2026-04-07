module RecordValidators
  module UrlInspector
    class TrustedSourceValidator
      TRUSTED_HOSTS = ["cdn-magnific.freepik.com"].freeze

      def initialize(uri:)
        @uri = uri
      end

      def valid?
        return false unless uri
        return false unless http_or_https?

        return false if host.blank?

        self.class::TRUSTED_HOSTS.include?(host)
      end

      private

      attr_reader :uri

      def host
        uri.host&.downcase
      end

      def http_or_https?
        uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      end
    end
  end
end
