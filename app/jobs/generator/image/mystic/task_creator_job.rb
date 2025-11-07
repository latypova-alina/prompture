module Generator
  module Image
    module Mystic
      class TaskCreatorJob < ::Generator::Image::BaseTaskCreatorJob
        API_URL = "https://api.freepik.com/v1/ai/mystic".freeze

        private

        def payload
          {
            "aspect_ratio": "social_story_9_16",
            "model": "zen",
            "filter_nsfw": false,
            "resolution": "2k"
          }
        end
      end
    end
  end
end
