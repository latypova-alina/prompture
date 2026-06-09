module Generator
  module Media
    module Video
      module CreateTask
        class StrategySelector < Generator::Media::CreateTask::StrategySelectorBase
          DEFAULT_PROMPT = "Animate the image naturally with realistic motion and camera movement.".freeze

          STRATEGIES = {
            "kling_2_1_pro_image_to_video" => KlingPayloadStrategy,
            "hailuo_02_standard_image_to_video" => Hailuo02StandardPayloadStrategy,
            "veo3_1_lite_image_to_video" => Veo31LitePayloadStrategy
          }.freeze

          private

          def prompt
            super.presence || DEFAULT_PROMPT
          end

          def strategies
            STRATEGIES
          end
        end
      end
    end
  end
end
