module Clients
  module ChatGpt
    class PromptGenerator
      include Memery

      API_URL = "https://api.openai.com/v1/chat/completions".freeze
      MODEL = "gpt-4o-mini".freeze

      def initialize(messages)
        @messages = messages
      end

      def response_body
        raise ChatGpt::NoResponseError unless response.success?

        body = JSON.parse(response.body)
        body.dig("choices", 0, "message", "content")
      end

      private

      attr_reader :messages

      delegate :connection, to: :chat_gpt_connection

      def response
        connection.post do |req|
          req.body = {
            model: MODEL,
            messages:
          }.to_json
        end
      end

      memoize def chat_gpt_connection
        Connection.new(API_URL)
      end
    end
  end
end
