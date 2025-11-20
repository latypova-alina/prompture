module Generator
  module Video
    module Kling
      class TaskCreatorJob < ::Generator::Video::TaskCreatorJob
        API_URL = "https://api.freepik.com/v1/ai/image-to-video/kling-v2-1-pro".freeze
        DURATION = "5".freeze
        SCALE = "0.9".freeze

        private

        def payload
          {
            duration: DURATION,
            cfg_scale: SCALE
          }
        end
      end
    end
  end
end
