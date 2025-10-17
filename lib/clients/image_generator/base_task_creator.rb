module Clients
  module ImageGenerator
    class BaseTaskCreator < BaseApiRequest
      include Memery

      def initialize(prompt)
        super()
        @prompt = prompt
      end

      def task_id
        response_body.dig("data", "task_id")
      end

      private

      memoize def response
        connection.post { |req| req.body = payload.to_json }
      end

      def payload
        raise NotImplementedError
      end
    end
  end
end
