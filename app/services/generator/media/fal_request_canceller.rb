module Generator
  module Media
    class FalRequestCanceller
      include Memery

      def initialize(request)
        @request = request
      end

      delegate :success?, :cancel_request, to: :fal_request_client

      private

      attr_reader :request

      memoize def fal_request_client
        FalRequestClient.new(request)
      end
    end
  end
end
