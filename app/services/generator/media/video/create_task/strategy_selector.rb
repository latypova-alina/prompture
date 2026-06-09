module Generator
  module Media
    module Video
      module CreateTask
        class StrategySelector < Generator::Media::CreateTask::StrategySelectorBase
          STRATEGIES = {
            "kling_2_1_pro_image_to_video" => KlingPayloadStrategy,
            "seedance_2_0_image_to_video" => SeedancePayloadStrategy
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
