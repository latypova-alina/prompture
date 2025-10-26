module Clients
  module Generator
    module Image
      module Gemini
        class TaskCreator < ::Clients::Generator::Image::BaseTaskCreator
          VERTICAL_IMAGE_URL = "https://prompture.s3.eu-central-1.amazonaws.com/vertical.jpg".freeze
          API_URL = "https://api.freepik.com/v1/ai/gemini-2-5-flash-image-preview".freeze

          private

          def payload
            {
              prompt: "#{prompt}\nThe same ratio as reference image.",
              reference_images: [VERTICAL_IMAGE_URL]
            }
          end
        end
      end
    end
  end
end
