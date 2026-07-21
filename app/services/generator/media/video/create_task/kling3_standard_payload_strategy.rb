module Generator
  module Media
    module Video
      module CreateTask
        class Kling3StandardPayloadStrategy
          API_URL = "https://queue.fal.run/fal-ai/kling-video/v3/standard/image-to-video".freeze
          DURATION = "5".freeze
          NEGATIVE_PROMPT = "blur, distort, and low quality".freeze

          def initialize(prompt, button_request:)
            @prompt = prompt
            @button_request = button_request
          end

          attr_reader :prompt, :button_request

          delegate :command_request, to: :button_request
          delegate :start_image_url, :end_image_url, to: :command_request

          def payload
            {
              prompt:,
              start_image_url:,
              end_image_url:,
              duration: DURATION,
              generate_audio: false,
              negative_prompt: NEGATIVE_PROMPT
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
