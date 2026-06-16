module Generator
  module Media
    class FalStatusResolver
      def initialize(request)
        @request = request
      end

      def status_text
        case fal_status
        when "IN_QUEUE", "IN_PROGRESS"
          I18n.t("errors.generation_status_in_progress")
        when "COMPLETED"
          I18n.t("errors.generation_status_completed")
        when "FAILED"
          I18n.t("errors.generation_status_failed")
        else
          I18n.t("errors.generation_status_unknown")
        end
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
