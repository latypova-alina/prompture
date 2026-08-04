module Fal
  module Webhook
    class HeaderReader
      def initialize(headers:)
        @headers = headers
      end

      def request_id
        headers["X-Fal-Webhook-Request-Id"]
      end

      def user_id
        headers["X-Fal-Webhook-User-Id"]
      end

      def timestamp
        headers["X-Fal-Webhook-Timestamp"]
      end

      def signature
        headers["X-Fal-Webhook-Signature"]
      end

      def present?
        [request_id, user_id, timestamp, signature].all?(&:present?)
      end

      private

      attr_reader :headers
    end
  end
end
