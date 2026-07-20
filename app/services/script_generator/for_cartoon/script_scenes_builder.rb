module ScriptGenerator
  module ForCartoon
    class ScriptScenesBuilder
      include Memery

      def initialize(payload:)
        @payload = payload
      end

      memoize def scenes
        raise ScriptGeneratorRequestError if extracted_scenes.blank?

        extracted_scenes
      end

      private

      attr_reader :payload

      memoize def extracted_scenes
        Array(payload["scenes"]).map(&:to_s).reject(&:blank?)
      end
    end
  end
end
