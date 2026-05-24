module ScriptGenerator
  module ForMotivation
    class ScenesParser
      include Memery

      def initialize(parsed_response_body:)
        @parsed_response_body = parsed_response_body
      end

      def parsed_scenes
        return scenes_from_objects if scene_validator.valid?

        nil
      end

      private

      attr_reader :parsed_response_body

      memoize def scene_validator
        SceneValidator.new(parsed_response_body)
      end

      def scenes_from_objects
        parsed_response_body.map do |item|
          VideoScene.new(
            prompt: item["prompt"],
            subcategory: normalized_subcategory(item["subcategory"])
          )
        end
      end

      def normalized_subcategory(subcategory)
        ContentCategory.normalize(subcategory).presence
      end
    end
  end
end
