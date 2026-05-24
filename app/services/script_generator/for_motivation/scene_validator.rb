module ScriptGenerator
  module ForMotivation
    class SceneValidator
      def initialize(scenes_array)
        @scenes_array = scenes_array
      end

      def valid?
        scenes_array.is_a?(Array) && scenes_array.all? { |item| valid_item?(item) }
      end

      private

      attr_reader :scenes_array

      def valid_item?(item)
        VideoScene.new(item).valid?
      end
    end
  end
end
