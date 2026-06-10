module Generator
  module Media
    module Image
      module CreateTask
        module PayloadEnhancers
          class CartoonScript
            ASPECT_RATIO = "16:9".freeze
            PROCESSORS = %w[nano_banana_image nano_banana_edit_image].freeze

            def self.applies_to?(request)
              request.command_request&.cartoon_script? &&
                PROCESSORS.include?(request.processor)
            end

            def initialize(request:, payload:)
              @request = request
              @payload = payload
            end

            def enhance
              return payload.merge(aspect_ratio: ASPECT_RATIO) if edit_image_processor?

              payload.merge(
                aspect_ratio: ASPECT_RATIO,
                image_urls: [resolved_image_url]
              )
            end

            private

            attr_reader :request, :payload

            delegate :parent_request, to: :request
            delegate :resolved_image_url, to: :parent_request

            def edit_image_processor?
              request.processor == "nano_banana_edit_image"
            end
          end
        end
      end
    end
  end
end
