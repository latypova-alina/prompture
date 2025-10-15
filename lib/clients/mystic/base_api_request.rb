module Clients
  module Mystic
    class BaseApiRequest
      include Memery

      API_URL = "https://api.freepik.com/v1/ai/mystic".freeze

      private

      delegate :connection, to: :mystic_connection

      def response
        raise NotImplementedError
      end

      def response_body
        raise ::Mystic::ResponseError unless response.success?

        JSON.parse(response.body)
      end

      def api_url
        self.class::API_URL
      end

      memoize def mystic_connection
        Connection.new(api_url)
      end
    end
  end
end
