module Generator
  module Media
    module Image
      module CreateTask
        class NanoBananaPayloadStrategy < PayloadStrategyBase
          API_URL = "https://queue.fal.run/fal-ai/nano-banana-2".freeze

          private

          def payload_params
            { aspect_ratio: "9:16" }
          end
        end
      end
    end
  end
end
