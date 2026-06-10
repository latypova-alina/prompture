module ScriptGenerator
  module ForCartoon
    class CartoonScriptReferenceImageUrl
      include Memery

      def self.call(...)
        new(...).call
      end

      def initialize(payload:)
        @payload = payload
      end

      def call
        raise ScriptGeneratorRequestError if reference_image_url.blank?

        reference_image_url
      end

      private

      attr_reader :payload

      memoize def reference_image_url
        payload["reference_image_url"].to_s.strip.presence
      end
    end
  end
end
