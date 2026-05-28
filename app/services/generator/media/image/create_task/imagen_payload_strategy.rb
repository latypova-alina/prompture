module Generator
  module Media
    module Image
      module CreateTask
        class ImagenPayloadStrategy < PayloadStrategyBase
          API_URL = "https://queue.fal.run/fal-ai/imagen4/preview/fast".freeze

          private

          def payload_params
            { aspect_ratio: "9:16" }
          end
        end
      end
    end
  end
end
