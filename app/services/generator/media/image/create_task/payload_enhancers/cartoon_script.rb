module Generator
  module Media
    module Image
      module CreateTask
        module PayloadEnhancers
          class CartoonScript
            ASPECT_RATIO = "16:9".freeze

            def self.applies_to?(request)
              request.command_request.try(:category) == ContentCategory::CARTOON_SCRIPT &&
                request.processor == "nano_banana_image"
            end

            def initialize(payload:, **)
              @payload = payload
            end

            def enhance
              payload.merge(
                aspect_ratio: ASPECT_RATIO,
                image_urls: [CartoonCharacter::ReferenceImageUrl.call]
              )
            end

            private

            attr_reader :payload
          end
        end
      end
    end
  end
end
