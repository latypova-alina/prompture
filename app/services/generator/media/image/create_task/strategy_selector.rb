module Generator
  module Media
    module Image
      module CreateTask
        class StrategySelector < Generator::Media::CreateTask::StrategySelectorBase
          EDIT_PROCESSORS = %w[nano_banana_edit_image].freeze

          STRATEGIES = {
            "flux_image" => FluxPayloadStrategy,
            "nano_banana_image" => NanoBananaPayloadStrategy,
            "nano_banana_edit_image" => NanoBananaEditPayloadStrategy
          }.freeze

          def strategies
            STRATEGIES
          end

          private

          delegate :command_request, to: :request
          delegate :prompt, to: :command_request, prefix: true

          def prompt
            return command_request_prompt if edit_processor?

            super
          end

          def edit_processor?
            EDIT_PROCESSORS.include?(processor)
          end
        end
      end
    end
  end
end
