module Clients
  module ImageGenerator
    class BaseApiRequest
      include Memery

      private

      attr_reader :prompt

      def response
        raise NotImplementedError
      end

      def response_body
        raise ::Freepik::ResponseError unless response.success?

        JSON.parse(response.body)
      end

      def api_url
        raise NotImplementedError unless self.class.const_defined?(:API_URL)

        self.class::API_URL
      end

      memoize def connection
        Connection.new(api_url).connection
      end
    end
  end
end
