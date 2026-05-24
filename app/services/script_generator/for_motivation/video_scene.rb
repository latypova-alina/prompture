module ScriptGenerator
  module ForMotivation
    class VideoScene
      def initialize(item)
        @item = item
      end

      def prompt
        item["text"].presence
      end

      def subcategory
        item["subcategory"].to_s.strip.presence
      end

      def valid?
        item.is_a?(Hash) && prompt.present? && subcategory.present?
      end

      private

      attr_reader :item
    end
  end
end
