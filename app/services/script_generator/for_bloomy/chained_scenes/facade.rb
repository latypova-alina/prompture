module ScriptGenerator
  module ForBloomy
    module ChainedScenes
      class Facade
        include Memery

        def initialize(button_request:)
          @button_request = button_request
        end

        delegate :script, :scenes, :next_scene, to: :context
        delegate :can_start_next_scene?, to: :next_scene_validator
        delegate :last_scene?, to: :last_scene_validator
        delegate :all_images_ready?, to: :all_images_ready_validator

        private

        attr_reader :button_request

        memoize def context
          Context.new(button_request:)
        end

        memoize def next_scene_validator
          NextSceneValidator.new(context:)
        end

        memoize def last_scene_validator
          LastSceneValidator.new(context:)
        end

        memoize def all_images_ready_validator
          AllImagesReadyValidator.new(context:)
        end
      end
    end
  end
end
