module ScriptGenerator
  module ForCartoon
    module SingleScript
      class Processor
        include Memery

        def self.call(...)
          new(...).call
        end

        def initialize(chat_id:, category: ContentCategory::CARTOON_SCRIPT)
          @chat_id = chat_id
          @category = category
        end

        def call
          Processors::ForImagePrompts.call(
            chat_id:,
            scenes: scene_records,
            reference_image_url:,
            category:
          )
        end

        private

        attr_reader :chat_id, :category

        delegate :scenes, :reference_image_url, to: :context

        memoize def context
          Context.new
        end

        memoize def script
          Script.create!(chained_references: false)
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
