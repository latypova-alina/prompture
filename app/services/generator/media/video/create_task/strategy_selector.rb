module Generator
  module Media
    module Video
      module CreateTask
        class StrategySelector < Generator::Media::CreateTask::StrategySelectorBase
          STRATEGIES = {
            "kling_2_1_pro_image_to_video" => KlingPayloadStrategy
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
