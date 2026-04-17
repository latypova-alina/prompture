module Generator
  module Media
    module Video
      module CreateTask
        class SeedancePayloadStrategy
          API_URL = "https://api.freepik.com/v1/ai/video/seedance-1-5-pro-720p".freeze
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
              generate_audio: false,
              camera_fixed: true,
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
