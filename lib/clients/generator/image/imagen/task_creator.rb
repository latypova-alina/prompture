module Clients
  module Generator
    module Image
      module Imagen
        class TaskCreator < ::Clients::Generator::Image::BaseTaskCreator
          API_URL = "https://api.freepik.com/v1/ai/text-to-image/imagen3".freeze

          private

          def payload
            {
              prompt:,
              "aspect_ratio": "social_story_9_16",
              "styling": {
                "style": "3d"
              }
            }
          end
        end
      end
    end
  end
end
