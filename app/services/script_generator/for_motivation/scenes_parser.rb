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
        parsed_response_body.map { |item| scene_from_item(item) }
      end

      def scene_from_item(item)
        VideoScene.new(prompt: prompt_for(item), subcategory: subcategory_for(item))
      end

      def prompt_for(item)
        item["prompt"].presence || item["text"].presence
      end

      def subcategory_for(item)
        item["subcategory"].to_s.strip.presence
      end
    end
  end
end
