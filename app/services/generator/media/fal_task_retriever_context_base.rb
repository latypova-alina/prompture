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
        urls = media_urls
        urls.present? ? urls : []
      end

      private

      attr_reader :params

      def payload
        params.fetch(:payload, {}).permit!
      end

      def media_urls
        raise NotImplementedError
      end
    end
  end
end
