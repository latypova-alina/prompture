module ScriptGenerator
  module ForBloomy
    module ChainedScenes
      class SceneImageUrl
        def initialize(scene:)
          @scene = scene
        end

        def image_url
          scene.image_prompt&.stored_images&.max_by(&:created_at)&.image_url
        end

        private

        attr_reader :scene
      end
    end
  end
end
