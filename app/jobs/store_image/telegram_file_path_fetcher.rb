require "faraday"
require "json"

module StoreImage
  class TelegramFilePathFetcher
    TELEGRAM_API_BASE = "https://api.telegram.org"

    def initialize(picture_id:)
      @picture_id = picture_id
    end

    def file_path
      uri = URI("#{TELEGRAM_API_BASE}/bot#{bot_token}/getFile?file_id=#{picture_id}")
      response = Faraday.get(uri.to_s)
      raise "Telegram getFile failed: #{response.status}" unless response.success?

      body = JSON.parse(response.body)
      raise "Telegram getFile response invalid" unless body["ok"]

      body.dig("result", "file_path") || raise("Telegram file_path missing")
    end

    private

    attr_reader :picture_id

    def bot_token
      ENV.fetch("TELEGRAM_BOT_TOKEN")
    end
  end
end
