module Generator
  module Media
    module Video
      module CreateTask
        class Veo31LitePayloadStrategy
          API_URL = "https://queue.fal.run/fal-ai/veo3.1/lite/image-to-video".freeze
          DURATION = 6
          ASPECT_RATIO = "9:16".freeze

          def initialize(prompt)
            @prompt = prompt
          end

          attr_reader :prompt

          def payload
            {
              prompt:,
              aspect_ratio: ASPECT_RATIO,
              duration: DURATION,
              generate_audio: false
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
