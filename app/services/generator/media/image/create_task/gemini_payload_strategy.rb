module Generator
  module Media
    module Image
      module CreateTask
        class GeminiPayloadStrategy
          VERTICAL_IMAGE_URL = "https://prompture.s3.eu-central-1.amazonaws.com/vertical.jpg".freeze
          API_URL = "https://api.freepik.com/v1/ai/gemini-2-5-flash-image-preview".freeze

          def initialize(prompt)
            @prompt = prompt
          end

          attr_reader :prompt

          def payload
            {
              prompt: "#{prompt}\nThe same ratio as reference image.",
              reference_images: [VERTICAL_IMAGE_URL]
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
