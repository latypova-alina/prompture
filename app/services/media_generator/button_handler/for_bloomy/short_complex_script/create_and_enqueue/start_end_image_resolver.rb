module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module ShortComplexScript
        module CreateAndEnqueue
          class StartEndImageResolver
            include Memery

            def initialize(start_scene:, end_scene:)
              @start_scene = start_scene
              @end_scene = end_scene
            end

            memoize def start_image_url
              scene_image_url(start_scene)
            end

            memoize def end_image_url
              scene_image_url(end_scene)
            end

            private

            attr_reader :start_scene, :end_scene

            def scene_image_url(scene)
              ScriptGenerator::ForBloomy::ChainedScenes::SceneImageUrl.new(scene:).image_url
            end
          end
        end
      end
    end
  end
end
