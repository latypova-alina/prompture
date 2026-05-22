module ScriptGenerator
  module ForMotivation
    class PromptsBaseContext
      include BaseContext

      def prompts
        handle_error

        parsed_prompts
      rescue Faraday::Error => e
        raise ScriptGeneratorRequestError, e.message
      end

      private

      def handle_error
        return if valid_response?

        raise ScriptGeneratorRequestError, response_body.to_s
      end

      def valid_response?
        response.success? && string_array?(parsed_prompts)
      end

      def string_array?(value)
        value.is_a?(Array) && value.all? { |item| item.is_a?(String) }
      end

      memoize def parsed_prompts
        string_array?(parsed_json_body) ? parsed_json_body : nil
      end
    end
  end
end
