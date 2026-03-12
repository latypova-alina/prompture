module Generator
  module Media
    TaskRetrieverContext = Struct.new(:params) do
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
        RequestIdToken.decode(request_id_token)
      end

      def generated
        body[:generated]
      end

      private

      def request_id_token
        params[:request_id_token]
      end

      def body
        params.require(:freepik_webhook).permit!
      end
    end
  end
end
