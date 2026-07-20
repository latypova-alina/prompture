module ScriptGenerator
  module ForBloomy
    module ShortComplexScript
      class ExtractSceneRecords
        include Interactor
        include Memery

        delegate :scenes, to: :context

        def call
          context.scene_records = scene_records
        end

        private

        memoize def script
          Script.create!(chained_references: true)
        end

        memoize def scene_records
          scenes.each_with_index.map do |scene_text, index|
            Scene.create!(script:, scene_text:, order: index + 1)
          end
        end
      end
    end
  end
end
