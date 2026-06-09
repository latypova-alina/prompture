module Generator
  module Media
    module Video
      module CreateTask
        class SeedancePayloadStrategy
          API_URL = "https://queue.fal.run/bytedance/seedance-2.0/image-to-video".freeze
          DURATION = 5
          ASPECT_RATIO = "9:16".freeze

          def initialize(prompt)
            @prompt = prompt
          end

          attr_reader :prompt

          def payload
            {
              prompt:,
              duration: DURATION,
              aspect_ratio: ASPECT_RATIO,
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
