module Generator
  module Image
    class TaskCreatorJob < BaseNotifierJob
      def perform(button_request_id)
        @button_request_id = button_request_id

        TaskCreatorDispatcher.call(request)
      rescue Freepik::ResponseError
        FailureHandler.call(request)
      end

      private

      attr_reader :button_request_id
    end
  end
end
