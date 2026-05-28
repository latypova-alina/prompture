module Generator
  module Media
    module Image
      module CreateTask
        class ImagenPayloadStrategy
          API_URL = "https://queue.fal.run/fal-ai/imagen4/preview/fast".freeze

          def initialize(prompt)
            @prompt = prompt
          end

          def payload
            {
              prompt:,
              aspect_ratio: "9:16"
            }
          end

          def webhook_param_name
            :fal_webhook
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
