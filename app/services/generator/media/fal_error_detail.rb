module Generator
  module Media
    # The "detail" of a fal error body, whether it came through the webhook or as a submit response.
    # Usually [{"type" => ..., "msg" => ...}], sometimes a bare string.
    class FalErrorDetail
      CONTENT_POLICY_VIOLATION = "content_policy_violation".freeze

      def initialize(body)
        @body = body.to_h.with_indifferent_access
      end

      def content_policy_violation?
        type == CONTENT_POLICY_VIOLATION
      end

      def message
        first_detail[:msg] if first_detail.is_a?(Hash)
      end

      private

      attr_reader :body

      def type
        first_detail.is_a?(Hash) ? first_detail[:type] : first_detail
      end

      def first_detail
        Array.wrap(body[:detail]).first
      end
    end
  end
end
