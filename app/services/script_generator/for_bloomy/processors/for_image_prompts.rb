module ScriptGenerator
  module ForCartoon
    module Processors
      class ForImagePrompts
        include Memery

        def self.call(...)
          new(...).call
        end

        def initialize(chat_id:, scenes:, reference_image_url:, category: ContentCategory::CARTOON_SCRIPT)
          @chat_id = chat_id
          @scenes = scenes
          @reference_image_url = reference_image_url
          @category = category
        end

        def call
          scenes.each do |scene|
            ForImagePrompt.call(scene:, script_processor:)
          end
        end

        private

        attr_reader :chat_id, :scenes, :reference_image_url, :category

        memoize def script_processor
          ScriptGenerator::ProcessScript::ForEditImage.new(
            chat_id:,
            category:,
            reference_image_url:
          )
        end
      end
    end
  end
end
