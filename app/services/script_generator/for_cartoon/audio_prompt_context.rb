module ScriptGenerator
  module ForCartoon
    class AudioPromptContext < ScriptGenerator::BaseContext
      def initialize(script_text:)
        super()
        @script_text = script_text
      end

      def audio_prompt
        handle_error

        parsed_audio_prompt
      rescue Faraday::Error => e
        raise ScriptGeneratorRequestError, e.message
      end

      private

      attr_reader :script_text

      def handle_error
        raise ScriptGeneratorRequestError if !response.success? || parsed_audio_prompt.blank?
      end

      memoize def parsed_audio_prompt
        response_payload["audio_prompt"].to_s.strip.presence
      end

      def response_payload
        parsed_json_body || {}
      end

      memoize def response
        connection.post("/generate_audio_prompt") do |request|
          request.body = request_body.to_json
        end
      end

      def request_body
        { script_text: }
      end
    end
  end
end
