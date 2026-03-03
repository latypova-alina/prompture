module Generator
  module Video
    module CreateTask
      class KlingPayloadStrategy
        API_URL = "https://api.freepik.com/v1/ai/image-to-video/kling-v2-1-pro".freeze
        DURATION = "5".freeze
        SCALE = "0.9".freeze

        def initialize(prompt)
          @prompt = prompt
        end

        attr_reader :prompt

        def payload
          {
            duration: DURATION,
            cfg_scale: SCALE,
            prompt:
          }
        end

        def api_url
          API_URL
        end
      end
    end
  end
end
