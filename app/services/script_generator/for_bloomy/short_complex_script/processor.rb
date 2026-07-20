module ScriptGenerator
  module ForBloomy
    module ShortComplexScript
      class Processor
        include Memery

        CATEGORY = ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT

        def self.call(...)
          new(...).call
        end

        def initialize(chat_id:)
          @chat_id = chat_id
        end

        def call
          create_image_prompts!
          start_first_scene_image_generation!
        end

        private

        attr_reader :chat_id

        delegate :scenes, :reference_image_url, to: :context

        def create_image_prompts!
          scene_records.each do |scene|
            SceneImagePromptCreator.call(scene:)
          end
        end

        def start_first_scene_image_generation!
          first_scene = scene_records.first
          return if first_scene.blank?

          ScriptGenerator::ProcessScript::ForEditImage.new(
            chat_id:,
            category: CATEGORY,
            reference_image_url:
          ).call(image_prompt_record: first_scene.image_prompt)
        end

        memoize def context
          Context.new
        end

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
