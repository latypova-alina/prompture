module ScriptGenerator
  module ForBloomy
    module ChainedScenes
      class LastSceneValidator
        def initialize(context:)
          @context = context
        end

        def last_scene?
          scene.present? && script&.chained_references? && next_scene.blank?
        end

        private

        attr_reader :context

        delegate :scene, :script, :next_scene, to: :context
      end
    end
  end
end
