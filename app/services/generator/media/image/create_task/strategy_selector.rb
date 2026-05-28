module Generator
  module Media
    module Image
      module CreateTask
        class StrategySelector < Generator::Media::CreateTask::StrategySelectorBase
          STRATEGIES = {
            "flux_image" => FluxPayloadStrategy,
            "nano_banana_image" => NanoBananaPayloadStrategy,
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
