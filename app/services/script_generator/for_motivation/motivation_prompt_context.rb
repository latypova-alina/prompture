module ScriptGenerator
  module ForMotivation
    class MotivationPromptContext
      include Memery

      def initialize(chat_id:)
        @chat_id = chat_id
      end

      def prompts
        handle_error

        parsed_prompts
      rescue Faraday::Error => e
        raise ScriptGeneratorRequestError, e.message
      end

      private

      attr_reader :chat_id

      def handle_error
        return if valid_response?

        raise ScriptGeneratorRequestError, response.body.to_s
      end

      def valid_response?
        response.success? && parsed_prompts.is_a?(Array) && parsed_prompts.all? { |prompt| prompt.is_a?(String) }
      end

      memoize def parsed_prompts
        response_payload
      end

      def response_payload
        body = response.body

        body.is_a?(String) ? JSON.parse(body) : body
      rescue JSON::ParserError
        nil
      end

      memoize def response
        connection.get("/motivation_prompt")
      end

      def connection
        ScriptGenerator::Connection.call
      end
    end
  end
end
