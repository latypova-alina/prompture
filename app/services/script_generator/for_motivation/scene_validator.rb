module ScriptGenerator
  module ForMotivation
    class SceneValidator
      def initialize(value)
        @value = value
      end

      def valid?
        value.is_a?(Array) && value.all? { |item| valid_scene_object?(item) }
      end

      private

      attr_reader :value

      def valid_scene_object?(item)
        item.is_a?(Hash) && item["prompt"].present? && normalized_subcategory(item["subcategory"]).present?
      end

      def normalized_subcategory(subcategory)
        ContentCategory.normalize(subcategory).presence
      end
    end
  end
end
