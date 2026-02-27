module Generator
  module Image
    module Imagen
      class PayloadStrategyForCreate
        API_URL = "https://api.freepik.com/v1/ai/text-to-image/imagen3".freeze

        def initialize(prompt)
          @prompt = prompt
        end

        def payload
          {
            prompt:,
            "aspect_ratio": "social_story_9_16",
            "styling": {
              "style": "3d"
            }
          }
        end

        attr_reader :prompt

        def api_url
          API_URL
        end
      end
    end
  end
end
