module Generator
  module Media
    module Image
      module CreateTask
        class NanoBananaEditPayloadStrategy < PayloadStrategyBase
          API_URL = "https://queue.fal.run/fal-ai/nano-banana-2/edit".freeze

          def payload
            { prompt: }
          end
        end
      end
    end
  end
end
