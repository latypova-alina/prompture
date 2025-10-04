module Clients
  module ChatGpt
    class Connection
      include Memery

      def initialize(url)
        @url = url
      end

      memoize def connection
        Faraday.new(
          url:,
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer #{ENV['OPENAI_API_KEY']}"
          }
        )
      end

      private

      attr_reader :url
    end
  end
end
