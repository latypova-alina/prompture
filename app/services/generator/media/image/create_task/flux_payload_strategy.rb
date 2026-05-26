module Generator
  module Media
    module Image
      module CreateTask
        class FluxPayloadStrategy
          API_URL = "https://api.fluxapi.ai/api/v1/flux/kontext/generate".freeze
          MODEL = "flux-kontext-pro".freeze

          def initialize(prompt)
            @prompt = prompt
          end

          def payload
            {
              prompt:,
              enableTranslation: true,
              aspectRatio: "9:16",
              outputFormat: "jpeg",
              promptUpsampling: false,
              model: MODEL,
              safetyTolerance: 2
            }
          end

          def webhook_param_name
            :callBackUrl
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
