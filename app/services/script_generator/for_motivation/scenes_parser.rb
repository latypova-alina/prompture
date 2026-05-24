module ScriptGenerator
  module ForMotivation
    class ScenesParser
      include Memery

      def initialize(parsed_response_body:)
        @parsed_response_body = parsed_response_body
      end

      def parsed_scenes
        return parsed_response_body.map { |item| VideoScene.new(item) } if scene_validator.valid?

        nil
      end

      private

      attr_reader :parsed_response_body

      memoize def scene_validator
        SceneValidator.new(parsed_response_body)
      end
    end
  end
end
