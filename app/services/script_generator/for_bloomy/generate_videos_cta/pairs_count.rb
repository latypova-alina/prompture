module ScriptGenerator
  module ForBloomy
    module GenerateVideosCta
      class PairsCount
        def initialize(scenes:)
          @scenes = scenes
        end

        def pairs_count
          [scenes.size - 1, 0].max
        end

        private

        attr_reader :scenes
      end
    end
  end
end
