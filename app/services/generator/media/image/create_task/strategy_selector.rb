module Generator
  module Media
    module Image
      module CreateTask
        class StrategySelector < Generator::Media::CreateTask::StrategySelectorBase
          STRATEGIES = {
            "mystic_image" => MysticPayloadStrategy,
            "flux_image" => FluxPayloadStrategy,
            "gemini_image" => GeminiPayloadStrategy,
            "imagen_image" => ImagenPayloadStrategy
          }.freeze

          def strategies
            STRATEGIES
          end
        end
      end
    end
  end
end
