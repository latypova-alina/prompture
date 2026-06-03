module Generator
  module Media
    module Video
      module CreateTask
        class KlingPayloadStrategy
          API_URL = "https://queue.fal.run/fal-ai/kling-video/v2.1/pro/image-to-video".freeze
          DURATION = 5

          def initialize(prompt)
            @prompt = prompt
          end

          attr_reader :prompt

          def payload
            {
              prompt:,
              duration: DURATION
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
