module Clients
  module Gemini
    class BaseApiRequest
      include Memery

      API_URL = "https://api.freepik.com/v1/ai/gemini-2-5-flash-image-preview".freeze

      private

      delegate :connection, to: :gemini_connection

      def response
        raise NotImplementedError
      end

      def response_body
        raise ::Gemini::ResponseError unless response.success?

        JSON.parse(response.body)
      end

      def api_url
        self.class::API_URL
      end

      memoize def gemini_connection
        Connection.new(api_url)
      end
    end
  end
end
