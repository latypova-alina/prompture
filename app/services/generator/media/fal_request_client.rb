module Generator
  module Media
    class FalRequestClient
      include Memery

      def initialize(request)
        @request = request
      end

      def status
        JSON.parse(response.body)["status"]
      end

      def cancel
        connection.put(cancel_url)
      end

      private

      attr_reader :request

      delegate :fal_request_id, :processor, to: :request
      delegate :status_url, :base_url, to: :url_resolver
      delegate :cancel_url, to: :cancel_url_resolver

      memoize def response
        connection.get(status_url)
      end

      memoize def url_resolver
        UrlResolver.new(fal_request_id:, processor:)
      end

      memoize def cancel_url_resolver
        CancelUrlResolver.new(fal_request_id:, processor:)
      end

      def connection
        Clients::Generator::Connection::Fal.new(base_url).connection
      end
    end
  end
end
