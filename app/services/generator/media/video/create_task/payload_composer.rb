module Generator
  module Media
    module Video
      module CreateTask
        class PayloadComposer < Generator::Media::CreateTask::PayloadComposerBase
          include Memery

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
            return [PayloadEnhancers::Default] if specific_enhancers.empty?

            specific_enhancers
          end

          memoize def specific_enhancers
            SPECIFIC_ENHANCERS.select { |klass| klass.applies_to?(request) }
          end
        end
      end
    end
  end
end
