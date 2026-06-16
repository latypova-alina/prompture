module Generator
  module Media
    class FalStatusResolver
      STATUS_TEXT_KEYS = {
        "IN_QUEUE" => "errors.generation_status_in_progress",
        "IN_PROGRESS" => "errors.generation_status_in_progress",
        "COMPLETED" => "errors.generation_status_completed",
        "FAILED" => "errors.generation_status_failed"
      }.freeze

      UNKNOWN_STATUS_TEXT_KEY = "errors.generation_status_unknown".freeze

      def initialize(request)
        @request = request
      end

      def status_text
        I18n.t(STATUS_TEXT_KEYS.fetch(fal_status, UNKNOWN_STATUS_TEXT_KEY))
      end

      private

      attr_reader :request

      def fal_status
        FalRequestClient.new(request).status
      rescue StandardError
        nil
      end
    end
  end
end
