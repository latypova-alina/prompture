module Clients
  module Mystic
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
        JSON.parse(
          File.read(Rails.root.join("config/payloads/mystic/zen_payload.json"))
        ).merge(prompt:)
      end
    end
  end
end
