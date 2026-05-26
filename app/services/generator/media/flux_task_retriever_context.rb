module Generator
  module Media
    class FluxTaskRetrieverContext
      def initialize(params:)
        @params = params
      end

      def task_id
        data[:taskId]
      end

      def processor
        params[:processor]
      end

      def status
        return "COMPLETED" if callback_code == 200

        "FAILED"
      end

      def button_request_id
        RequestIdToken.decode(params[:request_id_token])
      end

      def generated
        url = data.dig(:info, :resultImageUrl)
        url.present? ? [url] : []
      end

      private

      attr_reader :params

      def callback_code
        params[:code].to_i
      end

      def data
        params.fetch(:data, {}).permit!
      end
    end
  end
end
