module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module ShortComplexScript
        class ScenePairsBuilder
          def initialize(scenes:)
            @scenes = scenes
          end

          def scene_pairs
            Array(scenes).each_cons(2).to_a
          end

          private

          attr_reader :scenes
        end
      end
    end
  end
end
