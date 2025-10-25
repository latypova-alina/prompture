module Clients
  module Generator
    module Video
      module Kling
        class TaskCreator < ::Clients::Generator::Video::BaseTaskCreator
          API_URL = "https://api.freepik.com/v1/ai/image-to-video/kling-v2-1-pro".freeze
          DURATION = 5

          private

          def payload
            {
              prompt:,
              duration: "5",
              image: image_url
            }
          end
        end
      end
    end
  end
end
