module Generator
  module Media
    module Prompt
      module CreateTask
        class StrategySelector < Generator::Media::CreateTask::StrategySelectorBase
          STRATEGIES = {
            "extend_prompt" => ExtendPromptPayloadStrategy
          }.freeze

          private

          def strategies
            STRATEGIES
          end
        end
      end
    end
  end
end
