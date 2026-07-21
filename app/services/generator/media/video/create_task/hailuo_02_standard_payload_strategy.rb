module Generator
  module Media
    module Video
      module CreateTask
        class Hailuo02StandardPayloadStrategy
          API_URL = "https://queue.fal.run/fal-ai/minimax/hailuo-02/standard/image-to-video".freeze
          DURATION = 6

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
