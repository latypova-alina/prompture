module Generator
  module Media
    class RequestStatusResolver
      STATUS_TEXT_KEYS = {
        "IN_QUEUE" => "errors.generation_status_in_queue",
        "IN_PROGRESS" => "errors.generation_status_in_progress",
        "COMPLETED" => "errors.generation_status_completed",
        "FAILED" => "errors.generation_status_failed"
      }.freeze

      UNKNOWN_STATUS_TEXT_KEY = "errors.generation_status_unknown".freeze

      def initialize(request)
        @request = request
      end

      def status_text
        return in_queue_status_text if queued_locally?

        I18n.t(STATUS_TEXT_KEYS.fetch(fal_status, UNKNOWN_STATUS_TEXT_KEY))
      end

      private

      attr_reader :request

      def queued_locally?
        request.respond_to?(:fal_request_id) && request.fal_request_id.blank?
      end

      def in_queue_status_text
        I18n.t("errors.generation_status_in_queue")
      end

      def fal_status
        FalRequestClient.new(request).status
      rescue StandardError
        nil
      end
    end
  end
end
