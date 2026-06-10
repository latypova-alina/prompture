module ScriptGenerator
  module ForCartoon
    class CartoonScriptScenes
      include Memery

      def self.call(...)
        new(...).call
      end

      def initialize(payload:)
        @payload = payload
      end

      def call
        raise ScriptGeneratorRequestError if scenes.blank?

        scenes
      end

      private

      attr_reader :payload

      memoize def scenes
        Array(payload["scenes"]).map(&:to_s).reject(&:blank?)
      end
    end
  end
end
