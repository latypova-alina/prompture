module ScriptGenerator
  module ForCartoon
    class BaseContext < ScriptGenerator::BaseContext
      include Memery

      def initialize(script_text:)
        super()
        @script_text = script_text
      end

      def prompt
        handle_error

        parsed_prompt
      rescue Faraday::Error => e
        raise ScriptGeneratorRequestError, e.message
      end

      private

      attr_reader :script_text

      def endpoint_path
        raise NotImplementedError
      end

      def handle_error
        raise ScriptGeneratorRequestError if !response.success? || parsed_prompt.blank?
      end

      def parsed_prompt
        response_payload[response_payload_key].to_s.strip.presence
      end

      def response_payload_key
        raise NotImplementedError
      end

      def request_body
        raise NotImplementedError
      end

      memoize def response
        connection.post(endpoint_path) do |request|
          request.body = request_body.to_json
        end
      end
    end
  end
end
