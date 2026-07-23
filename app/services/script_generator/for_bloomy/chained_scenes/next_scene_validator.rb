module ScriptGenerator
  module ForBloomy
    module ChainedScenes
      class NextSceneValidator
        def initialize(context:)
          @context = context
        end

        def can_start_next_scene?
          next_scene.present? &&
            next_scene.image_prompt.present? &&
            !next_scene.image_prompt.stored_images.exists?
        end

        private

        attr_reader :context

        delegate :next_scene, to: :context
      end
    end
  end
end
