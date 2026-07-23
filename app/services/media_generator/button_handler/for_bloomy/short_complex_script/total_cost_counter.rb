module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module ShortComplexScript
        class TotalCostCounter
          PROCESSOR = "kling_3_standard_image_to_video".freeze

          def initialize(scene_pairs:)
            @scene_pairs = scene_pairs
          end

          def total_cost
            cost_per_video * scene_pairs.size
          end

          private

          attr_reader :scene_pairs

          def cost_per_video
            COSTS[:generate_video][PROCESSOR.to_sym]
          end
        end
      end
    end
  end
end
