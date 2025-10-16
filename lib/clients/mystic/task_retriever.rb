module Clients
  module Mystic
    class TaskRetriever < BaseApiRequest
      include Memery

      def initialize(task_id)
        super()
        @task_id = task_id
      end

      def status
        response_body.dig("data", "status")
      end

      def image_url
        response_body.dig("data", "generated")
      end

      private

      attr_reader :task_id

      memoize def response
        connection.get(task_id)
      end
    end
  end
end
