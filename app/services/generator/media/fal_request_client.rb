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

      private

      attr_reader :request

      delegate :fal_request_id, :processor, to: :request
      delegate :status_url, :base_url, to: :status_url_resolver

      memoize def response
        connection.get(status_url)
      end

      memoize def status_url_resolver
        StatusUrlResolver.new(fal_request_id:, processor:)
      end

      def connection
        Clients::Generator::Connection::Fal.new(base_url).connection
      end
    end
  end
end
