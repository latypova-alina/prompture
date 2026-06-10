module Generator
  module Media
    module Video
      module CreateTask
        class PayloadComposer < Generator::Media::CreateTask::PayloadComposerBase
          SPECIFIC_ENHANCERS = [
            PayloadEnhancers::CartoonScript
          ].freeze

          def final_payload
            enhanced_payload.merge(image_url:)
          end

          private

          delegate :image_url, to: :request

          def enhanced_payload
            applicable_enhancers.reduce(strategy.payload) do |current_payload, enhancer_class|
              enhancer_class.new(request:, payload: current_payload).enhance
            end
          end

          def applicable_enhancers
            specific = SPECIFIC_ENHANCERS.select { |klass| klass.applies_to?(request) }
            return [PayloadEnhancers::Default] if specific.empty?

            specific
          end
        end
      end
    end
  end
end
