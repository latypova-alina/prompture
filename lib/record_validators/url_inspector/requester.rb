module RecordValidators
  module UrlInspector
    class Requester
      include Memery

      def initialize(uri:, method:, headers: {})
        @uri = uri
        @method = method
        @headers = headers
      end

      def run(redirects: 0)
        response = perform_request
        return response unless redirect_response?(response)

        redirect_follower.follow(redirect_context(response:, redirects:))
      rescue Faraday::Error, Timeout::Error
        nil
      end

      private

      attr_reader :uri, :method, :headers

      def redirect_response?(response)
        (300..399).cover?(response.status)
      end

      def perform_request
        connection_for_uri.run_request(method, request_path, nil, headers)
      end

      def redirect_context(response:, redirects:)
        RedirectContext.new(
          response:,
          current_uri: uri,
          method_type: method,
          headers:,
          redirects:
        )
      end

      def request_path
        uri.request_uri.presence || "/"
      end

      def connection_for_uri
        connection_factory.build(uri)
      end

      memoize def connection_factory
        ConnectionFactory.new
      end

      memoize def redirect_follower
        RedirectFollower.new
      end
    end
  end
end
