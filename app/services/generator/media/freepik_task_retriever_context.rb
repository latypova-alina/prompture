module Generator
  module Media
    class FreepikTaskRetrieverContext
      def initialize(params:)
        @params = params
      end

      def task_id
        body[:task_id]
      end

      def processor
        params[:processor]
      end

      def status
        body[:status]
      end

      def button_request_id
        RequestIdToken.decode(params[:request_id_token])
      end

      def generated
        body[:generated]
      end

      private

      attr_reader :params

      def body
        params.require(:freepik_webhook).permit!
      end
    end
  end
end
