module Generator
  module Media
    class FalTaskRetrieverContextBase
      CANCELLATION_STATUS_CODE = "499"

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
        return "CANCELLED" if cancelled?

        "FAILED"
      end

      def button_request_id
        RequestIdToken.decode(params[:request_id_token])
      end

      def generated
        media_urls.present? ? media_urls : []
      end

      private

      attr_reader :params

      def cancelled?
        params[:error].to_s.include?(CANCELLATION_STATUS_CODE)
      end

      def payload
        params.fetch(:payload, {}).permit!
      end

      def media_urls
        raise NotImplementedError
      end
    end
  end
end
