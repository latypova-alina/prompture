module ScriptGenerator
  module ForBloomy
    module ShortComplexScript
      class CreateImagePrompts
        include Interactor

        delegate :scene_records, to: :context

        def call
          scene_records.each do |scene|
            SceneImagePromptCreator.call(scene:)
          end
        end
      end
    end
  end
end
