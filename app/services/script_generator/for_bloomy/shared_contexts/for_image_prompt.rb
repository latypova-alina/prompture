module ScriptGenerator
  module ForBloomy
    module SharedContexts
      class ForImagePrompt < Base
        private

        def endpoint_path
          "/generate_image_prompt"
        end

        def response_payload_key
          "image_prompt"
        end

        def request_body
          { script_text: }
        end
      end
    end
  end
end
