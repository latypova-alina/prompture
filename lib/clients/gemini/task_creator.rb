module Clients
  module Gemini
    class TaskCreator < BaseApiRequest
      include Memery

      def initialize(prompt)
        super()
        @prompt = prompt
      end

      def task_id
        response_body.dig("data", "task_id")
      end

      private

      attr_reader :prompt

      memoize def response
        connection.post { |req| req.body = payload.to_json }
      end

      def payload
        { prompt: }
      end
    end
  end
end
