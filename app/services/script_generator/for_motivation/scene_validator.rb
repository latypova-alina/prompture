module ScriptGenerator
  module ForMotivation
    class SceneValidator
      def initialize(parsed_response_body)
        @parsed_response_body = parsed_response_body
      end

      def valid?
        parsed_response_body.is_a?(Array) && parsed_response_body.all? { |item| valid_item?(item) }
      end

      private

      attr_reader :parsed_response_body

      def valid_item?(item)
        item.is_a?(Hash) && prompt_for(item).present? && subcategory_for(item).present?
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
