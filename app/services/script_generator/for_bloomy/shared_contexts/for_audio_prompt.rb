module ScriptGenerator
  module ForBloomy
    module SharedContexts
      class ForAudioPrompt < Base
        private

        def response_payload_key
          "audio_prompt"
        end

        def endpoint_path
          "/audio_prompt_for_bloomy_single_scene"
        end

        def request_body
          { script_text: }
        end
      end
    end
  end
end
