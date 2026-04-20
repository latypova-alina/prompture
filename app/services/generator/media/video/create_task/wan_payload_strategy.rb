module Generator
  module Media
    module Video
      module CreateTask
        class WanPayloadStrategy
          API_URL = "https://api.freepik.com/v1/ai/image-to-video/wan-v2-2-720p".freeze
          DURATION = "5".freeze
          ASPECT_RATIO = "social_story_9_16".freeze

          def initialize(prompt)
            @prompt = prompt
          end

          attr_reader :prompt

          def payload
            {
              duration: DURATION,
              prompt:,
              aspect_ratio: ASPECT_RATIO
            }
          end

          def api_url
            API_URL
          end
        end
      end
    end
  end
end
