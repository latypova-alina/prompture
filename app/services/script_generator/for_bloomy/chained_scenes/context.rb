module ScriptGenerator
  module ForBloomy
    module ChainedScenes
      class Context
        include Memery

        def initialize(button_request:)
          @button_request = button_request
        end

        delegate :script, to: :scene, allow_nil: true
        delegate :scenes, to: :script, allow_nil: true

        memoize def next_scene
          return if script.blank? || !script.chained_references?

          scenes.find { |scene_record| scene_record.order == scene_order + 1 }
        end

        memoize def scene
          return if image_prompt_id.blank?

          Scene.includes(script: :scenes).find_by(image_prompt_id:)
        end

        private

        attr_reader :button_request

        delegate :command_request, to: :button_request
        delegate :image_prompt_id, to: :command_request
        delegate :order, to: :scene, allow_nil: true, prefix: true
      end
    end
  end
end
