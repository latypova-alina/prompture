module Generator
  module Media
    class CancelFalRequest
      def initialize(request)
        @request = request
      end

      def call
        return unless success?

        request.update!(status: "CANCELLED")

        Interim::MessageDeleter.call(request:)
      end

      delegate :success?, to: :response

      private

      attr_reader :request

      def response
        FalRequestClient.new(request).cancel
      end
    end
  end
end
