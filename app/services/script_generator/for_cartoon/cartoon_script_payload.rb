module ScriptGenerator
  module ForCartoon
    class CartoonScriptPayload < ScriptGenerator::BaseContext
      def self.call(...)
        new(...).call
      end

      def call
        handle_error

        response_payload
      rescue Faraday::Error => e
        raise ScriptGeneratorRequestError, e.message
      end

      private

      def handle_error
        raise ScriptGeneratorRequestError unless response.success?
      end

      def response_payload
        parsed_json_body || {}
      end

      memoize def response
        connection.get("/cartoon_script")
      end
    end
  end
end
