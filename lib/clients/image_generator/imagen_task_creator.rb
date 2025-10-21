module Clients
  module ImageGenerator
    class ImagenTaskCreator < BaseTaskCreator
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
