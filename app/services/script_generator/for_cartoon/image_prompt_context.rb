module ScriptGenerator
  module ForCartoon
    class ImagePromptContext < ScriptGenerator::BaseContext
      def initialize(script_text:)
        super()
        @script_text = script_text
      end

      def image_prompt
        handle_error

        parsed_image_prompt
      rescue Faraday::Error => e
        raise ScriptGeneratorRequestError, e.message
      end

      private

      attr_reader :script_text

      def handle_error
        raise ScriptGeneratorRequestError if !response.success? || parsed_image_prompt.blank?
      end

      memoize def parsed_image_prompt
        response_payload["image_prompt"].to_s.strip.presence
      end

      def response_payload
        parsed_json_body || {}
      end

      memoize def response
        connection.post("/generate_image_prompt") do |request|
          request.body = request_body.to_json
        end
      end

      def request_body
        { script_text: }
      end
    end
  end
end
