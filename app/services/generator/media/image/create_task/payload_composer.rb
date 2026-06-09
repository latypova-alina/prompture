module Generator
  module Media
    module Image
      module CreateTask
        class PayloadComposer < Generator::Media::CreateTask::PayloadComposerBase
          ENHANCERS = [
            PayloadEnhancers::EditImage,
            PayloadEnhancers::CartoonScript,
            PayloadEnhancers::Default
          ].freeze

          def final_payload
            enhancer_class.new(request:, payload:).enhance
          end

          private

          delegate :payload, to: :strategy

          def enhancer_class
            ENHANCERS.find { |klass| klass.applies_to?(request) }
          end
        end
      end
    end
  end
end
