module ScriptGenerator
  module ForMotivation
    class MotivationScriptContext
      include BaseContext

      def initialize(language: "en")
        @language = language
      end

      def script_text
        handle_error

        parsed_script_text
      rescue Faraday::Error => e
        raise ScriptGeneratorRequestError, e.message
      end

      private

      attr_reader :language

      def handle_error
        raise ScriptGeneratorRequestError if !response.success? || parsed_script_text.blank?
      end

      memoize def parsed_script_text
        response_payload["script"].to_s
      end

      def response_payload
        parsed_json_body || {}
      end

      memoize def response
        connection.get("/motivation_script", { language: })
      end
    end
  end
end
