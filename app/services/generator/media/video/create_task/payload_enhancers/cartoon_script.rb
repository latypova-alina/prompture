module Generator
  module Media
    module Video
      module CreateTask
        module PayloadEnhancers
          class CartoonScript
            ASPECT_RATIO = "16:9".freeze
            PROCESSOR = "veo3_1_lite_image_to_video".freeze

            def self.applies_to?(request)
              request.command_request.cartoon_script? &&
                request.processor == PROCESSOR
            end

            def initialize(request:, payload:)
              @request = request
              @payload = payload
            end

            def enhance
              payload.merge(aspect_ratio: ASPECT_RATIO)
            end

            private

            attr_reader :request, :payload
          end
        end
      end
    end
  end
end
