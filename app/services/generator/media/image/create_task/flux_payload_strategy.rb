module Generator
  module Media
    module Image
      module CreateTask
        class FluxPayloadStrategy
          API_URL = "https://queue.fal.run/fal-ai/flux/dev".freeze

          def initialize(prompt)
            @prompt = prompt
          end

          def payload
            {
              prompt:,
              image_size: "portrait_16_9"
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
