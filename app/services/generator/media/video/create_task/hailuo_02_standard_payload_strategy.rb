module Generator
  module Media
    module Video
      module CreateTask
        class Hailuo02StandardPayloadStrategy
          API_URL = "https://queue.fal.run/fal-ai/minimax/hailuo-02/standard/image-to-video".freeze
          DURATION = 6

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
