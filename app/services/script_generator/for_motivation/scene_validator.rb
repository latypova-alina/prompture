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
        VideoScene.new(item).valid?
      end
    end
  end
end
