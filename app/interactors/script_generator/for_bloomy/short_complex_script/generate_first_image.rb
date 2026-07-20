module ScriptGenerator
  module ForBloomy
    module ShortComplexScript
      class GenerateFirstImage
        include Interactor
        include Memery

        CATEGORY = ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT

        delegate :chat_id, :reference_image_url, :scene_records, to: :context

        def call
          return if first_scene.blank?

          ScriptGenerator::ProcessScene::ForEditImage.new(
            chat_id:,
            category: CATEGORY,
            reference_image_url:
          ).call(image_prompt_record: image_prompt)
        end

        private

        delegate :image_prompt, to: :first_scene

        memoize def first_scene
          scene_records.first
        end
      end
    end
  end
end
