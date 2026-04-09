require "faraday"

module StoreImage
  module Download
    class UrlImageDownloader
      def self.call(...)
        new(...).call
      end

      def initialize(url)
        @url = url
      end

      def call
        raise "Image download failed: #{response.status}" unless response.success?

        response.body
      end

      private

      attr_reader :url

      def uri
        URI(url)
      end

      def response
        Faraday.get(uri.to_s)
      end
    end
  end
end
