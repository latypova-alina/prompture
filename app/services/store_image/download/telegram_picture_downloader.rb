require "faraday"

module StoreImage
  module Download
    class TelegramPictureDownloader
      TELEGRAM_API_BASE = "https://api.telegram.org".freeze

      def self.call(...)
        new(...).call
      end

      def initialize(picture_id:)
        @picture_id = picture_id
      end

      def call
        raise "Telegram picture download failed: #{response.status}" unless response.success?

        response.body
      end

      private

      attr_reader :picture_id

      delegate :file_path, to: :file_path_fetcher

      def download_uri
        URI("#{TELEGRAM_API_BASE}/file/bot#{telegram_bot_token}/#{file_path}")
      end

      def response
        Faraday.get(download_uri.to_s)
      end

      def file_path_fetcher
        TelegramFilePathFetcher.new(picture_id:)
      end

      def telegram_bot_token
        ENV.fetch("TELEGRAM_BOT_TOKEN")
      end
    end
  end
end
