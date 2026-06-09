module ScriptGenerator
  module ForCartoon
    class CartoonScriptContext < ScriptGenerator::BaseContext
      def scenes
        handle_error

        parsed_scenes
      rescue Faraday::Error => e
        raise ScriptGeneratorRequestError, e.message
      end

      private

      def handle_error
        raise ScriptGeneratorRequestError if !response.success? || parsed_scenes.blank?
      end

      memoize def parsed_scenes
        Array(response_payload["scenes"]).map(&:to_s).reject(&:blank?)
      end

      def response_payload
        parsed_json_body || {}
      end

      memoize def response
        connection.get("/cartoon_script", { character_name: CartoonCharacter::Name.call })
      end
    end
  end
end
