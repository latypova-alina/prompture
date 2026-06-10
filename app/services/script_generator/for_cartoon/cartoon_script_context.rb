module ScriptGenerator
  module ForCartoon
    class CartoonScriptContext < ScriptGenerator::BaseContext
      def scenes
        handle_error

        parsed_scenes
      rescue Faraday::Error => e
        raise ScriptGeneratorRequestError, e.message
      end

      def reference_image_url
        handle_error

        parsed_reference_image_url
      rescue Faraday::Error => e
        raise ScriptGeneratorRequestError, e.message
      end

      private

      def handle_error
        raise ScriptGeneratorRequestError if invalid_response?
      end

      def invalid_response?
        !response.success? || parsed_scenes.blank? || parsed_reference_image_url.blank?
      end

      memoize def parsed_scenes
        Array(response_payload["scenes"]).map(&:to_s).reject(&:blank?)
      end

      memoize def parsed_reference_image_url
        response_payload["reference_image_url"].to_s.strip.presence
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
