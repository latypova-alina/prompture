module Generator
  module Media
    class TaskCreatorBaseJob < ApplicationJob
      include Memery

      def perform(button_request_id)
        @button_request_id = button_request_id

        task_creator_class.call(request)
      rescue Freepik::ResponseError => e
        failure_handler_class.call(request, error: e)
      end

      private

      attr_reader :button_request_id

      def task_creator_class
        raise NotImplementedError
      end

      def failure_handler_class
        raise NotImplementedError
      end

      def request_class
        raise NotImplementedError
      end

      memoize def request
        request_class.includes(:parent_request, command_request: :user).find(button_request_id)
      end
    end
  end
end
