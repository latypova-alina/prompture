module ScriptGenerator
  module ForCartoon
    module SharedContexts
      class ForVideoPrompt < Base
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
end
