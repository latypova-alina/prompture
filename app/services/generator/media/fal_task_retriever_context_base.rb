module Generator
  module Media
    class FalTaskRetrieverContextBase
      def initialize(params:)
        @params = params
      end

      def task_id
        params[:request_id]
      end

      def processor
        params[:processor]
      end

      def status
        return "COMPLETED" if params[:status] == "OK"

        "FAILED"
      end

      def button_request_id
        RequestIdToken.decode(params[:request_id_token])
      end

      def generated
        media_urls.present? ? media_urls : []
      end

      def error_reason
        "content_flagged" if content_policy_violation?
      end

      def flagged_message
        error_detail[:msg]
      end

      private

      attr_reader :params

      def payload
        params.fetch(:payload, {}).permit!
      end

      def media_urls
        raise NotImplementedError
      end

      def content_policy_violation?
        error_detail[:type] == "content_policy_violation"
      end

      def error_detail
        Array(payload[:detail]).first || {}
      end
    end
  end
end
