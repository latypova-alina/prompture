require "open-uri"

module StoreImage
  module Download
    class UrlImageDownloader
      BROWSER_USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0 Safari/537.36".freeze
      BROWSER_REFERER = "https://www.freepik.com/".freeze

      def self.call(...)
        new(...).call
      end

      def initialize(url)
        @url = url
      end

      def call
        file.read
      rescue OpenURI::HTTPError => e
        raise "Image download failed: #{e.io.status.first}"
      end

      private

      attr_reader :url

      def file
        URI.open(
          url,
          {
            "User-Agent" => BROWSER_USER_AGENT,
            "Referer" => BROWSER_REFERER
          }
        )
      end
    end
  end
end
