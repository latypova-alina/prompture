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
        fal_error_detail.message
      end

      private

      attr_reader :params

      def payload
        params.fetch(:payload, {}).permit!
      end

      def media_urls
        raise NotImplementedError
      end

      delegate :content_policy_violation?, to: :fal_error_detail

      def fal_error_detail
        Generator::Media::FalErrorDetail.new(payload)
      end
    end
  end
end
