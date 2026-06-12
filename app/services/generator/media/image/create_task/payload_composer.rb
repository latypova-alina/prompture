module Generator
  module Media
    module Image
      module CreateTask
        class PayloadComposer < Generator::Media::CreateTask::PayloadComposerBase
          include Memery

          SPECIFIC_ENHANCERS = [
            PayloadEnhancers::EditImage,
            PayloadEnhancers::CartoonScript,
            PayloadEnhancers::CartoonShortsScript
          ].freeze

          def final_payload
            applicable_enhancers.reduce(payload) do |current_payload, enhancer_class|
              enhancer_class.new(request:, payload: current_payload).enhance
            end
          end

          private

          delegate :payload, to: :strategy

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
