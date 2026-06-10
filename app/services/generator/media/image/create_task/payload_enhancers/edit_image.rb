module Generator
  module Media
    module Image
      module CreateTask
        module PayloadEnhancers
          class EditImage
            PROCESSORS = %w[nano_banana_edit_image].freeze

            def self.applies_to?(request)
              PROCESSORS.include?(request.processor)
            end

            def initialize(request:, payload:)
              @request = request
              @payload = payload
            end

            def enhance
              payload.merge(image_urls: [resolved_image_url])
            end

            private

            attr_reader :request, :payload

            delegate :parent_request, to: :request
            delegate :resolved_image_url, to: :parent_request
          end
        end
      end
    end
  end
end
