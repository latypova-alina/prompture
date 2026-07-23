module ScriptGenerator
  module ForBloomy
    module GenerateVideosCta
      class ReadyForCtaValidator
        def initialize(chained_scenes:)
          @chained_scenes = chained_scenes
        end

        def ready_for_cta?
          script&.chained_references? && last_scene? && all_images_ready?
        end

        private

        attr_reader :chained_scenes

        delegate :script, :last_scene?, :all_images_ready?, to: :chained_scenes
      end
    end
  end
end
