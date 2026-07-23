module ScriptGenerator
  module ForBloomy
    module ChainedScenes
      class AllImagesReadyValidator
        def initialize(context:)
          @context = context
        end

        def all_images_ready?
          return false if script.blank? || scenes.blank?

          scenes.includes(image_prompt: :stored_images).all? do |scene_record|
            SceneImageUrl.new(scene: scene_record).image_url.present?
          end
        end

        private

        attr_reader :context

        delegate :script, :scenes, to: :context
      end
    end
  end
end
