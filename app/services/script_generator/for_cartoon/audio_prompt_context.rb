module ScriptGenerator
  module ForCartoon
    class AudioPromptContext < BaseContext
      private

      def response_payload_key
        "audio_prompt"
      end

      def endpoint_path
        "/generate_audio_prompt"
      end

      def request_body
        { script_text: }
      end
    end
  end
end
