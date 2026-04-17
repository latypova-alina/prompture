module Generator
  module Media
    module Image
      module CreateTask
        class FluxPayloadStrategy
          API_URL = "https://api.freepik.com/v1/ai/text-to-image/flux-2-pro".freeze

          def initialize(prompt)
            @prompt = prompt
          end

          def payload
            {
              prompt:,
              "width": 768,
              "height": 1440
            }
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
