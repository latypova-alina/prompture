require "faraday"

module StoreImage
  class UrlImageDownloader
    def self.call(url)
      new(url).call
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
