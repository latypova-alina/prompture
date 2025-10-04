module Clients
  module Mystic
    class Connection
      include Memery

      def initialize(url)
        @url = url
      end

      memoize def connection
        Faraday.new(url:) do |f|
          f.headers["Content-Type"] = "application/json"
          f.headers["Accept"] = "application/json"
          f.headers["x-freepik-api-key"] = ENV["FREEPIK_API_KEY"]
          f.adapter Faraday.default_adapter
        end
      end

      private

      attr_reader :url
    end
  end
end
