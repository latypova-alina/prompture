module ScriptGenerator
  module ForCartoon
    class VideoPromptContext < BaseContext
      private

      def endpoint_path
        "/generate_video_prompt"
      end

      def response_payload_key
        "video_prompt"
      end

      def request_body
        { script_text: }
      end
    end
  end
end
