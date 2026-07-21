module Generator
  module Media
    module Video
      module CreateTask
        class Veo31LitePayloadStrategy
          API_URL = "https://queue.fal.run/fal-ai/veo3.1/lite/image-to-video".freeze
          DURATION = 6
          ASPECT_RATIO = "auto".freeze

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
