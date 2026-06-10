module Generator
  module Media
    module Image
      module CreateTask
        class PayloadComposer < Generator::Media::CreateTask::PayloadComposerBase
          SPECIFIC_ENHANCERS = [
            PayloadEnhancers::EditImage,
            PayloadEnhancers::CartoonScript
          ].freeze

          def final_payload
            applicable_enhancers.reduce(payload) do |current_payload, enhancer_class|
              enhancer_class.new(request:, payload: current_payload).enhance
            end
          end

          private

          delegate :payload, to: :strategy

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
