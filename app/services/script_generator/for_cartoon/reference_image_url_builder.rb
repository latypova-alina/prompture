module ScriptGenerator
  module ForCartoon
    class ReferenceImageUrlBuilder
      include Memery

      def initialize(payload:)
        @payload = payload
      end

      memoize def reference_image_url
        raise ScriptGeneratorRequestError if extracted_reference_image_url.blank?

        extracted_reference_image_url
      end

      private

      attr_reader :payload

      memoize def extracted_reference_image_url
        payload["reference_image_url"].to_s.strip.presence
      end
    end
  end
end
