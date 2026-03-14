module Generator
  module Media
    module Image
      module CreateTask
        class MysticPayloadStrategy
          API_URL = "https://api.freepik.com/v1/ai/mystic".freeze

          def initialize(prompt)
            @prompt = prompt
          end

          def payload
            {
              prompt:,
              "aspect_ratio": "social_story_9_16",
              "model": "zen",
              "filter_nsfw": false,
              "resolution": "2k"
            }
          end

          def api_url
            API_URL
          end

          attr_reader :prompt
        end
      end
    end
  end
end
