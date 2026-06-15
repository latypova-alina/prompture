require "open-uri"

module StoreImage
  module Download
    class RemoteUrlDownloader
      BROWSER_USER_AGENT = [
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
        "AppleWebKit/537.36 (KHTML, like Gecko)",
        "Chrome/122.0 Safari/537.36"
      ].join(" ").freeze
      def initialize(url)
        @url = url
      end

      def downloaded_bytes
        file.read
      rescue OpenURI::HTTPError => e
        raise "Download failed: #{e.io.status.first}"
      end

      private

      attr_reader :url

      def file
        # rubocop:disable Security/Open
        URI.open(
          url,
          { "User-Agent" => BROWSER_USER_AGENT }
        )
        # rubocop:enable Security/Open
      end
    end
  end
end
