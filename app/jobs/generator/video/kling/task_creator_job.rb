module Generator
  module Video
    module Kling
      class TaskCreatorJob < ::Generator::Image::BaseTaskCreatorJob
        API_URL = "https://api.freepik.com/v1/ai/image-to-video/kling-v2-1-pro".freeze
        DURATION = 5

        private

        def payload
          {
            duration: "5",
            cfg_scale: "0.9"
          }
        end
      end
    end
  end
end
