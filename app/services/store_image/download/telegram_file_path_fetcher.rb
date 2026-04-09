require "faraday"
require "json"

module StoreImage
  module Download
    class TelegramFilePathFetcher
      TELEGRAM_API_BASE = "https://api.telegram.org".freeze

      def initialize(picture_id:)
        @picture_id = picture_id
      end

      def file_path
        raise "Telegram getFile failed: #{response.status}" unless response.success?

        raise "Telegram getFile response invalid" unless parsed_response_body["ok"]

        parsed_response_body.dig("result", "file_path") || raise("Telegram file_path missing")
      end

      private

      attr_reader :picture_id

      def file_path_uri
        URI("#{TELEGRAM_API_BASE}/bot#{bot_token}/getFile?file_id=#{picture_id}")
      end

      def response
        Faraday.get(file_path_uri.to_s)
      end

      def parsed_response_body
        JSON.parse(response.body)
      end

      def bot_token
        ENV.fetch("TELEGRAM_BOT_TOKEN")
      end
    end
  end
end
