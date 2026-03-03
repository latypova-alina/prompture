module Generator
  module Image
    class TaskCreatorJob < BaseNotifierJob
      def perform(button_request_id)
        @button_request_id = button_request_id

        CreateTask::TaskCreator.call(request)
      rescue Freepik::ResponseError
        CreateTask::FailureHandler.call(request)
      end

      private

      attr_reader :button_request_id
    end
  end
end
