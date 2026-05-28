module Generator
  module Media
    module Image
      module CreateTask
        class FluxPayloadStrategy < PayloadStrategyBase
          API_URL = "https://queue.fal.run/fal-ai/flux-2-pro".freeze

          private

          def payload_params
            { image_size: "portrait_16_9" }
          end
        end
      end
    end
  end
end
