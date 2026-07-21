module Generator
  module Media
    module Video
      module CreateTask
        class StrategySelector < Generator::Media::CreateTask::StrategySelectorBase
          DEFAULT_PROMPT = "Animate the image naturally with realistic motion and camera movement.".freeze
          TWO_FRAME_DEFAULT_PROMPT = "Create a smooth transition from the start image to the end image.".freeze

          STRATEGIES = {
            "kling_2_1_pro_image_to_video" => KlingPayloadStrategy,
            "kling_3_standard_image_to_video" => Kling3StandardPayloadStrategy,
            "hailuo_02_standard_image_to_video" => Hailuo02StandardPayloadStrategy,
            "veo3_1_lite_image_to_video" => Veo31LitePayloadStrategy
          }.freeze

          def strategy
            strategy_class.new(resolved_prompt, button_request:)
          end

          private

          def resolved_prompt
            prompt.presence || default_prompt
          end

          def default_prompt
            return TWO_FRAME_DEFAULT_PROMPT if two_frame_processor?

            DEFAULT_PROMPT
          end

          def strategies
            STRATEGIES
          end

          memoize def strategy_class
            strategies.fetch(processor)
          end

          memoize def two_frame_processor?
            processor == "kling_3_standard_image_to_video"
          end
        end
      end
    end
  end
end
