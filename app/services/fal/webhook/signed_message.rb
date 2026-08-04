module Fal
  module Webhook
    class SignedMessage
      def initialize(request_id:, user_id:, timestamp:, body:)
        @request_id = request_id
        @user_id = user_id
        @timestamp = timestamp
        @body = body
      end

      def to_s
        [request_id, user_id, timestamp, body_digest].join("\n")
      end

      private

      attr_reader :request_id, :user_id, :timestamp, :body

      def body_digest
        Digest::SHA256.hexdigest(body.to_s)
      end
    end
  end
end
