module Generator
  module Media
    module Video
      module CreateTask
        class KlingPayloadStrategy
          API_URL = "https://queue.fal.run/fal-ai/kling-video/v2.1/pro/image-to-video".freeze
          DURATION = 5

          def initialize(prompt, button_request:)
            @prompt = prompt
            @button_request = button_request
          end

          attr_reader :prompt, :button_request

          delegate :image_url, to: :button_request

          def payload
            {
              prompt:,
              image_url:,
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
